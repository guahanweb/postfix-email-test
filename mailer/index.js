const config = require("./config");
const nodemailer = require("nodemailer");
const v4 = require("uuid").v4;
const express = require("express");

main();

function main() {
    const app = express();
    app.use(express.json());

    app.post('/:messageId', handler);

    const server = app.listen(config.port, () => {
        console.log(`App listening at http://${config.host}:${config.port}`);
        execTest();
    });

    function handler(req, res) {
        console.log("callback for message:", req.params.messageId);
        console.log(req.body);
        res.send("ok");
        server.close();
    }
}

function execTest() {
    const transport = nodemailer.createTransport({
        port: config.postfixPort,
        host: config.postfixHost,
        tls: {
            rejectUnauthorized: false
        }
    });

    const messageId = v4();
    transport.sendMail({
        from: "fizzbuzz@mydomain.com",
        to: "foobar@example.com",
        subject: "This is my subject",
        text: "Here is the content!",
        html: "<p>Here is the HTML version of the content!</p>",
        headers: {
            "x-message-id": messageId,
            "x-message-callback": `http://${config.host}:${config.port}`
        },
    }, function (err) {
        if (err) {
            return console.error(err);
        }
        console.log("email sent!");
    });
}
