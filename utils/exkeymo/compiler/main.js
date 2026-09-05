#!/usr/bin / env node

import fs from 'node:fs/promises';
import { buildApk } from './builder.js';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const args = process.argv.slice(2);
const inputFilePath = args[0];
const outputFilePath = args[1];

if (!inputFilePath) {
    console.error("Error: No input file specified.");
    process.exit(1);
}

try {
    const inputFileContent = await fs.readFile(inputFilePath, 'utf-8');

    console.log(inputFileContent);

    console.log(outputFilePath)

    console.log(buildApk)

    // console.log('Compiling APK...');
    // const apkBytes = await buildApk(inputFileContent, null);

    // console.log(`Writing APK to: ${outputFilePath}`);
    // await fs.writeFile(outputFilePath, Buffer.from(apkBytes));

    // console.log('Build complete!');

} catch (err) {
    console.error(`Error reading file "${inputFilePath}":`, err.message);
    process.exit(1);
}


