#!/usr/bin / env node

import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const args = process.argv.slice(2);
const inputFilePath = args[0];
const outputFilePath = args[1];

if (!inputFilePath) {
    console.error("Error: No input file specified.");
    process.exit(1);
}

// 1. Resolve path to ~/Projects/exkeymo/js/builder.js
const homeDir = process.env.HOME;
const exkeymoJsDir = path.join(homeDir, 'Projects/exkeymo/js');
const builderPath = path.join(exkeymoJsDir, 'builder.js');

try {
    const { buildApk } = await import(`file://${builderPath}`);

    const inputFileContent = await fs.readFile(inputFilePath, 'utf-8');

    console.log(inputFileContent);

    console.log(outputFilePath)

    console.log(buildApk)

} catch (err) {
    console.error(`Error reading file "${inputFilePath}":`, err.message);
    process.exit(1);
}


