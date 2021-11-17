#!/bin/bash

[ "${DEBUG}" == "yes" ] && set -x

function add_config_value() {
    local key=${1}
    local value=${2}
    # local config_file=${3:-/etc/postfix/main.cf}
    [ "${key}" = "" ] && echo "ERROR: No key set !!" && exit 1
    [ "${value}" == "" ] && echo "ERROR: No value set !!" && exit 1

    echo "Setting configuration option ${key} with value: ${value}"
    postconf -e "${key} = ${value}"
}

# Read variables from env
# [ -z "${SMTP_SERVER}" ] && echo "SMTP_SERVER is not set" && exit 1
[ -z "${SERVER_HOSTNAME}" ] && echo "SERVER_HOSTNAME is not set" && exit 1

SMTP_PORT="${SMTP_PORT:-587}"
DOMAIN=`echo ${SERVER_HOSTNAME} | awk 'BEGIN{FS=OFS="."}{print $(NF-1),$NF}'`

# Set necessary config options
add_config_value "maillog_file" "/dev/stdout"
add_config_value "myhostname" ${SERVER_HOSTNAME}
add_config_value "mydomain" ${DOMAIN}
add_config_value "mydestination" "${DESTINATION:-localhost}"
add_config_value "myorigin" '$mydomain'
add_config_value "relayhost" "[${SMTP_SERVER}]:${SMTP_PORT}"

# Check for subnet restrictions
nets='10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16'
add_config_value "mynetworks" "${nets}"

# Register the email_route transport
echo -e "email_route   unix  -       n       n       -       1000       pipe\n" >> /etc/postfix/master.cf
echo -e "  flags=Rq user=appuser null_sender=\n" >> /etc/postfix/master.cf
echo -e "  argv=/usr/local/bin/node /app/router.js \${sender} \${recipient}\n" >> /etc/postfix/master.cf

# Create the actual transport
echo -e "*      email_route:" > /etc/postfix/transport

# create the redirect.regexp to route all email
echo -e "/.*/ email_route:" > /etc/postfix/redirect.regexp
postmap /etc/postfix/redirect.regexp

# register the transport maps
postconf -e 'transport_maps = regexp:/etc/postfix/redirect.regexp'

# run postfix
exec /usr/sbin/postfix -c /etc/postfix start-fg
