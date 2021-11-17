FROM node:16-alpine

RUN apk update && \
    apk add bash gawk cyrus-sasl cyrus-sasl-login cyrus-sasl-crammd5 mailx \
    postfix && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /var/log/supervisor/ /var/run/supervisor/ && \
    sed -i -e 's/inet_interfaces  localhost/inet_interfaces = all/g' /etc/postfix/main.cf

RUN which node
RUN addgroup -S appgroup && adduser -u 1001 -S appuser -s /bin/bash -G appgroup

COPY run.sh /
COPY app /app
RUN chown -R appuser:appgroup /app

RUN chmod +x /run.sh
RUN newaliases

EXPOSE 25
CMD ["/run.sh"]
