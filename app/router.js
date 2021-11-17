const config = require('./config');
const readline = require("readline");
const axios = require("axios");

const logger = require('./lib/logger').getLogger({
  dir: config.LOG_PATH
});

const [,, callbackUrl, emailFrom, emailTo] = process.argv;
const params = {
    to: emailTo,
    from: emailFrom,
    raw: "",
    id: null,
};

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false,
});

rl.on("line", function (line) {
    const match = line.match(/^x-message-id\:\s+(.+)$/i);
    if (!!match) {
        // we found the message id
        params.id = match[1];
    }
    params.raw += `${line}\n`;
});

rl.on("close", function () {
    // post the body to our test endpoint
    if (params.id === null) {
        logger.warn("no x-message-id header found!");
        process.exit(1);
    }

    handleCallback(params)
        .then(() => console.log("callback executed!"))
        .catch((err) => console.error(err))
        .finally(() => process.exit());
});

function handleCallback(params) {
    return new Promise((resolve, reject) => {
        const url = `${callbackUrl}/${params.id}`;
        console.log("sending to:", url);

        axios.post(url, params)
            .then(resolve)
            .catch(reject);
    });
}
