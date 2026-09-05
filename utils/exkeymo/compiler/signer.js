// v1 (JAR) APK signing. Produces MANIFEST.MF, the .SF file, and the PKCS#7
// .RSA detached signature. This mirrors ch.cern.test.mdm.utils.SignedJar
// from the Java project with setDirectSignature(true) — no signed attributes,
// signature is computed directly over the .SF bytes.

import {
    sequence, set, octetString, nullValue,
    explicitCtx, implicitCtx, integer, oid, pemToDer, parseCertIssuerAndSerial,
} from './der.js';

const ENC = new TextEncoder();
const SIG_FN = 'META-INF/INTERMED.SF';
const SIG_RSA_FN = 'META-INF/INTERMED.RSA';
const MANIFEST_FN = 'META-INF/MANIFEST.MF';

const OID_SIGNED_DATA        = '1.2.840.113549.1.7.2';
const OID_DATA               = '1.2.840.113549.1.7.1';
const OID_SHA1               = '1.3.14.3.2.26';
const OID_SHA1_RSA           = '1.2.840.113549.1.1.5';

// ---- Web Crypto helpers --------------------------------------------------
async function sha1(bytes) {
    const h = await crypto.subtle.digest('SHA-1', bytes);
    return new Uint8Array(h);
}

function base64(bytes) {
    let s = '';
    for (let i = 0; i < bytes.length; i++) s += String.fromCharCode(bytes[i]);
    return btoa(s);
}

async function importRsaSigningKey(pkcs8Der) {
    return crypto.subtle.importKey(
        'pkcs8',
        pkcs8Der,
        { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-1' },
        false,
        ['sign']
    );
}

// ---- Manifest writer -----------------------------------------------------
// Replicates the byte-for-byte output of java.util.jar.Manifest.write for our
// needs: CRLF line endings, 72-char wrap with continuation-line prefix,
// Manifest-Version / Signature-Version emitted first in the main section,
// blank line at the end of each section.

function make72Safe(line) {
    // Java's make72Safe operates on chars. All our inputs are ASCII so chars ≡ bytes.
    let out = '';
    let idx = 0;
    while (line.length - idx > 72) {
        out += line.substring(idx, idx + 72) + '\r\n ';
        idx += 72;
    }
    out += line.substring(idx);
    return out;
}

function writeAttrLine(name, value) {
    return make72Safe(`${name}: ${value}`) + '\r\n';
}

/**
 * @param {Array<[string, string]>} mainAttrs - ordered main-section attributes; first entry must be the *-Version line
 * @param {Array<{name: string, attrs: Array<[string,string]>}>} entries - per-file sections
 * @returns {Uint8Array} serialized manifest/SF bytes
 */
function writeManifestLike(mainAttrs, entries) {
    let s = '';
    for (const [k, v] of mainAttrs) s += writeAttrLine(k, v);
    s += '\r\n';
    for (const e of entries) {
        s += writeAttrLine('Name', e.name);
        for (const [k, v] of e.attrs) s += writeAttrLine(k, v);
        s += '\r\n';
    }
    return ENC.encode(s);
}

/**
 * Per-entry section bytes for digesting — mirrors SignedJar.hashEntrySection.
 * Constructs a manifest containing just this one entry section, with its
 * attributes in the same order as when written, and returns the section
 * bytes (excluding the Manifest-Version main section).
 */
function entrySectionBytes(name, attrs) {
    let s = writeAttrLine('Name', name);
    for (const [k, v] of attrs) s += writeAttrLine(k, v);
    s += '\r\n';
    return ENC.encode(s);
}

// ---- Top-level signing ---------------------------------------------------
/**
 * Given a list of regular (non-META-INF) entries, compute the v1 signature
 * files and return them as three extra entries to prepend to the ZIP
 * (META-INF/MANIFEST.MF, META-INF/INTERMED.SF, META-INF/INTERMED.RSA),
 * mirroring SignedJar's output order.
 *
 * @param {Array<{name: string, data: Uint8Array}>} fileEntries
 * @param {string} certPem
 * @param {string} keyPem  PKCS#8 private key in PEM
 * @returns {Promise<Array<{name: string, data: Uint8Array}>>}  Three entries: manifest, sf, rsa.
 */
export async function signV1(fileEntries, certPem, keyPem) {
    const certDer = pemToDer(certPem, 'CERTIFICATE');
    const keyDer = pemToDer(keyPem, 'PRIVATE KEY');

    const createdBy = 'ExKeyMo static (browser)';

    // --- MANIFEST.MF ---
    const manifestMain = [
        ['Manifest-Version', '1.0'],
        ['Created-By', createdBy],
    ];
    const manifestEntries = [];
    const fileDigests = [];
    for (const fe of fileEntries) {
        const digestB64 = base64(await sha1(fe.data));
        manifestEntries.push({ name: fe.name, attrs: [['SHA1-Digest', digestB64]] });
        fileDigests.push({ name: fe.name, attrs: [['SHA1-Digest', digestB64]] });
    }
    const manifestBytes = writeManifestLike(manifestMain, manifestEntries);

    // Full-manifest digest (for Digest-Manifest in SF main)
    const manifestHash = base64(await sha1(manifestBytes));

    // Main-section-only digest (for Digest-Manifest-Main-Attributes in SF main)
    const mainOnlyBytes = writeManifestLike(manifestMain, []);
    const manifestMainHash = base64(await sha1(mainOnlyBytes));

    // Per-entry-section digests (for per-file Digest in SF)
    const sectionDigests = [];
    for (const e of manifestEntries) {
        const secBytes = entrySectionBytes(e.name, e.attrs);
        sectionDigests.push({ name: e.name, digest: base64(await sha1(secBytes)) });
    }

    // --- .SF ---
    const sfMain = [
        ['Signature-Version', '1.0'],
        ['Created-By', createdBy],
        ['SHA1-Digest-Manifest', manifestHash],
        ['SHA1-Digest-Manifest-Main-Attributes', manifestMainHash],
    ];
    const sfEntries = sectionDigests.map(({ name, digest }) => ({
        name,
        attrs: [['SHA1-Digest', digest]],
    }));
    const sfBytes = writeManifestLike(sfMain, sfEntries);

    // --- .RSA (PKCS#7 SignedData over sfBytes, detached, no signed attrs) ---
    const signingKey = await importRsaSigningKey(keyDer.buffer);
    const sigBuf = await crypto.subtle.sign('RSASSA-PKCS1-v1_5', signingKey, sfBytes);
    const signature = new Uint8Array(sigBuf);
    const rsaBytes = buildPkcs7SignedData(certDer, signature);

    return [
        { name: MANIFEST_FN, data: manifestBytes },
        { name: SIG_FN, data: sfBytes },
        { name: SIG_RSA_FN, data: rsaBytes },
    ];
}

/**
 * Build a PKCS#7 (CMS) SignedData ContentInfo with:
 * - no signed attributes (direct signature)
 * - detached content (no eContent)
 * - SHA-1 + rsaEncryption+SHA1 (sha1WithRSAEncryption signatureAlgorithm)
 * - IssuerAndSerialNumber as signer identifier
 * - certificate included in [0] IMPLICIT SET
 */
function buildPkcs7SignedData(certDer, signature) {
    const { issuer, serial } = parseCertIssuerAndSerial(certDer);

    const digestAlgSha1 = sequence(oid(OID_SHA1), nullValue());
    const digestAlgorithms = set(digestAlgSha1);
    const encapContentInfo = sequence(oid(OID_DATA)); // no eContent → detached

    const certificates = implicitCtx(0, certDer);

    // SignerInfo
    const version = integer(1);
    const sid = sequence(issuer, serial);
    const sigAlg = sequence(oid(OID_SHA1_RSA), nullValue());
    const signerInfo = sequence(
        version,
        sid,
        digestAlgSha1,
        sigAlg,
        octetString(signature),
    );
    const signerInfos = set(signerInfo);

    const signedData = sequence(
        integer(1),
        digestAlgorithms,
        encapContentInfo,
        certificates,
        signerInfos,
    );

    return sequence(oid(OID_SIGNED_DATA), explicitCtx(0, signedData));
}
