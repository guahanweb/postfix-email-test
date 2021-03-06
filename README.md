# POSTFIX Email Testing

Very few application stacks on which I have worked take the time to do
full round-trip E2E testing on their email delivery. What I mean by that
is we rigorously test the generated email content, but it can be quite
difficult to send the email to an inbox and then retrieve/test the
**delivered** content of that email, including transport headers and
any additional encoding.

This project is one way to set up an ephemeral email delivery system to
receive inbound messages and relay the final transport content back
into the test script.

## Overall Logical Flow

![sequence diagram](./sequence.png)

## Getting Started

After cloning the repo, you can build and run the docker image locally
in order to send emails to it. By default, the POSTFIX transport is
configured to post **all email** back to the sending scripts by using
custom email headers.

### Start up the POSTFIX Docker Container

```bash
# clone the repo
$ cd postfix-email-test
# build the image
$ docker build -t postfix_test:local .
# run the image
$ docker run \
    -e "SERVER_HOSTNAME=mail.example.com" \ # whatever your test domain is
    -p 1337:25 \ # expose TCP port
    -t postfix_test:local
```

At this point, you will be able to connect to the container and send
email through to your domain (`*@example.com` in this case).

### Send Test Email via Telnet

Yes, Telnet is still a thing and is a great way to test connections to
the newly running docker image. Assuming you bound a port mapping to
localhost 1337 (as in the default example), the following dialog will 
allow you to send a test email:

```sh
$ telnet localhost 1337
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
220 mail.example.com ESMTP Postfix
HELO example.com # send a HELO to connect
250 mail.example.com
MAIL FROM:<fizzbuzz@mydomain.com> # send from anything
250 2.1.0 Ok
RCPT TO:<foobar@example.com> # send to any example.com
250 2.1.5 Ok
DATA # data command tells the body is coming
354 End data with <CR><LF>.<CR><LF>
Subject: This is my subject # headers first

Here is the content of my email! #content

. # done
250 2.0.0 Ok: queued as 2A61EF89C8
```

If you see that your message was queued, everything worked properly.

### Send Test Email via Script

Now that you know POSTFIX is working properly, you can begin sending
emails and testing them programmatically. In this repo, there is a
sample script to show how this can be done with Node.js, and you can
execute the following to see a round-trip.

```bash
$ HOST="host.docker.internal" PORT=5000 node mailer
```

When building your test script, there are a few things to remember.

#### Required Email Headers

In order to have the POSTFIX container connect back to your script,
the following email headers must be provided.

* `x-message-id` - a UUID the calling script can reference
* `x-message-callback` - a URL to which the message should be POSTed

#### Response Routing

When both headers are provided, the raw content of the email will be
provided back at the following route:

```http
POST http://<x-message-callback>/<x-message-id>

{
    "to": "foobar@example.com",
    "from": "fizzbuzz@mydomain.com",
    "id": "<x-message-id>",
    "raw": "<the raw email content>"
}
```
