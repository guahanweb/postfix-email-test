const host = getFromEnv("HOST", "localhost");
const port = getFromEnv("PORT", 3000);

module.exports = {
    host,
    port,
};

function getFromEnv(prop, defaultValue = null) {
    const override = process.env && process.env[prop];
    return override || defaultValue;
}