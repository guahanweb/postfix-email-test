const nodemailer = require("nodemailer");
const v4 = require("uuid").v4;
const express = require("express");

main();

function main() {
    const port = 3000;
    const app = express();
    app.use(express.json());

    app.post('/:messageId', handler);

    const server = app.listen(port, () => {
        console.log(`App listening at http://localhost:${port}`);
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
        port: 1337,
        host: 'localhost',
        tls: {
            rejectUnauthorized: false
        }
    });

    const messageId = v4();
    transport.sendMail({
        from: "garth@guahanweb.com",
        to: "test@example.com",
        subject: "Message title",
        text: "Plaintext version",
        html: "<p>HTML version</p>",
        headers: {
            "x-message-id": messageId,
        },
    }, function (err) {
        if (err) {
            return console.error(err);
        }
        console.log("email sent!");
    });
}
