const config = require('./config');
const readline = require("readline");

const logger = require('./lib/logger').getLogger({
  dir: config.LOG_PATH
});

const [,,emailFrom, emailTo] = process.argv;
logger.info(`email recieved! (from: ${emailFrom}, to: ${emailTo}`);

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false,
});

let body = "";
rl.on("line", function (line) {
    body += `${line}\n`;
});

rl.on("close", function () {
    // post the body to our test endpoint
    logger.info(`  ${body}`);
    process.exit();
});
