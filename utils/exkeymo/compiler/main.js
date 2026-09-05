#!/usr/bin / env node

import fs from 'node:fs/promises';
import { buildApk } from './builder.js';

const args = process.argv.slice(2);
const inputFilePath = args[0];
const outputFilePath = args[1];

if (!inputFilePath) {
    console.error("Error: No input file specified.");
    process.exit(1);
}

const inputFileContent = await fs.readFile(inputFilePath, 'utf-8');

console.log('Compiling APK...');
const apkBytes = await buildApk(inputFileContent, null);

console.log(`Writing APK to: ${outputFilePath}`);
await fs.writeFile(outputFilePath, Buffer.from(apkBytes));

console.log('Build complete!');

