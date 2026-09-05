#!/usr/bin/env node

console.log("Hello World from ExKeyMo CLI compiler!");

// Print any arguments passed from the shell
const args = process.argv.slice(2);
if (args.length > 0) {
    console.log("Target input file:", args[0]);
    console.log("Target output file:", args[1]);
}

