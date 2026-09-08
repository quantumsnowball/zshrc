#!/usr/bin / env node

import fs from 'node:fs/promises';
import { buildApk } from './builder.js';

const args = process.argv.slice(2);
const layoutFilePath = args[0];
const outputFilePath = args[1];

if (!layoutFilePath || !outputFilePath) {
    console.error("Usage: exkeymo.compile-kcm-to-apk <input.kcm> <output.apk>");
    process.exit(1);
}

console.log('Compiling APK...');
const apkBytes = await buildApk(layoutFilePath);

console.log(`Writing APK to: ${outputFilePath}`);
await fs.writeFile(outputFilePath, Buffer.from(apkBytes));

console.log('Build complete!');

