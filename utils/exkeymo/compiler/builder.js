// Orchestrates APK build: loads a template APK (one- or two-layout variant),
// swaps in the user-supplied .kcm contents, and writes a freshly v1-signed APK.
//
// Mirrors ApkBuilder.java:
//  - Iterates entries of the template APK (skipping directories and any
//    pre-existing META-INF/* signature files — the template is unsigned).
//  - Replaces res/Q2.kcm with the first layout; replaces res/_f.kcm with the
//    optional second layout.
//  - Re-signs the resulting ZIP via signer.js.

import fs from 'node:fs/promises';
import path from 'node:path';
import { unzip, zip } from './zip.js';
import { signV1 } from './signer.js';

const KEYBOARD_LAYOUT_FILE_NAME = 'res/Q2.kcm';
const KEYBOARD_LAYOUT2_FILE_NAME = 'res/_f.kcm';

const ENC = new TextEncoder();

// Lazy asset loaders — everything's relative to the page that imported this module.
async function loadAsset(relPath) {
    const absolutePath = path.resolve(import.meta.dirname, relPath);
    return await fs.readFile(absolutePath);
}

async function loadBinary(relPath) {
    const buf = await loadAsset(relPath);
    return new Uint8Array(buf);
}

async function loadText(relPath) {
    const absolutePath = path.resolve(import.meta.dirname, relPath);
    return await fs.readFile(absolutePath, 'utf-8');
}

/**
 * Build a signed APK.
 * @param {string} layout   Final .kcm content for res/Q2.kcm
 * @param {string|null} layout2  Final .kcm content for res/_f.kcm, or null to use one-layout template
 * @returns {Promise<Uint8Array>}
 */
export async function buildApk(layout, layout2) {
    const templatePath = layout2 == null
        ? 'assets/app-oneLayout-release-unsigned.apk'
        : 'assets/app-twoLayouts-release-unsigned.apk';
    const [templateBytes, certPem, keyPem] = await Promise.all([
        loadBinary(templatePath),
        loadText('assets/cert.pem'),
        loadText('assets/key.pem'),
    ]);

    const entries = await unzip(templateBytes);

    // Replace .kcm entries and drop any pre-existing META-INF/* signature
    // artifacts (the template isn't signed but this keeps things safe).
    const patched = [];
    for (const e of entries) {
        if (e.name.startsWith('META-INF/') && (e.name.endsWith('.SF') || e.name.endsWith('.RSA') || e.name.endsWith('.DSA') || e.name.endsWith('.EC') || e.name === 'META-INF/MANIFEST.MF')) continue;
        if (e.name === KEYBOARD_LAYOUT_FILE_NAME) { patched.push({ name: e.name, data: ENC.encode(layout) }); continue; }
        if (layout2 != null && e.name === KEYBOARD_LAYOUT2_FILE_NAME) { patched.push({ name: e.name, data: ENC.encode(layout2) }); continue; }
        patched.push({ name: e.name, data: e.data });
    }

    const signatureEntries = await signV1(patched, certPem, keyPem);

    // Mirror SignedJar's write order: META-INF/MANIFEST.MF first, then the
    // .SF, then the .RSA, then all the file entries.
    const finalOrder = [...signatureEntries, ...patched];
    return zip(finalOrder);
}

/** Load a base .kcm by name (or null for the built-in default). */
export async function loadBaseKcm(name) {
    if (!name) return null;
    try {
        return await loadText(`assets/kcm/${name}`);
    } catch {
        return null;
    }
}

/**
 * Collect user-supplied fromN/toN pairs into a scan-code -> android-key map.
 * Empty values are ignored (matches the server's `serveApkWithSimpleLayouts`).
 */
export function collectSimpleMappings(formData) {
    const mappings = new Map();
    for (const [key, rawValue] of formData.entries()) {
        const value = typeof rawValue === 'string' ? rawValue : '';
        if (!key.startsWith('from')) continue;
        if (value === '') continue;
        const to = formData.get('to' + key.substring(4));
        if (!to) continue;
        mappings.set(value, to);
    }
    return mappings;
}

export function downloadBlob(bytes, filename) {
    const blob = new Blob([bytes], { type: 'application/vnd.android.package-archive' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    a.remove();
    setTimeout(() => URL.revokeObjectURL(url), 1000);
}
