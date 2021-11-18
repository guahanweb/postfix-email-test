const host = getFromEnv("HOST", "localhost");
const port = getFromEnv("PORT", 3000);
const postfixHost = getFromEnv("POSTFIX_HOST", "localhost");
const postfixPort = getFromEnv("POSTFIX_PORT", 1337);

module.exports = {
    host,
    port,
    postfixHost,
    postfixPort,
};

function getFromEnv(prop, defaultValue = null) {
    const override = process.env && process.env[prop];
    return override || defaultValue;
}