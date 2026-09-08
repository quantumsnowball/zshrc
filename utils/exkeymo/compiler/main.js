#!/usr/bin / env node

import fs from 'node:fs/promises';
import { buildApk } from './builder.js';

const args = process.argv.slice(2);
const layoutPath = args[0];
const templatePath = args[1];
const outputPath = args[2];

console.log('Compiling APK...');
const apkBytes = await buildApk(layoutPath, templatePath);

console.log(`Writing APK to: ${outputPath}`);
await fs.writeFile(outputPath, Buffer.from(apkBytes));

console.log('Build complete!');

