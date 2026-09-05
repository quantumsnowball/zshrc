#!/usr/bin / env node

import fs from 'node:fs/promises';

const args = process.argv.slice(2);
const inputFile = args[0];
const outputFile = args[1];

if (!inputFile) {
    console.error("Error: No input file specified.");
    process.exit(1);
}

try {
    // Read file as UTF-8 string
    const inputFileContent = await fs.readFile(inputFile, 'utf-8');

    // Print content to stdout
    console.log(inputFileContent);

    console.log(outputFile)

} catch (err) {
    console.error(`Error reading file "${inputFile}":`, err.message);
    process.exit(1);
}


