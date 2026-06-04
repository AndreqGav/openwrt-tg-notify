#!/bin/sh
. /lib/functions.sh
config_load tg-notify
config_get enabled main enabled 1
[ "$enabled" = "1" ] || exit 0
config_get token   main token
config_get chat_id main chat_id
config_get interface main interface
TEXT="$1"
[ -n "$token" ] && [ -n "$chat_id" ] || exit 0
IFACE_OPT=""
[ -n "$interface" ] && IFACE_OPT="--interface $interface"
curl -s $IFACE_OPT "https://api.telegram.org/bot${token}/sendMessage" \
  --data-urlencode "chat_id=${chat_id}" \
  --data-urlencode "text=${TEXT}" \
  --data-urlencode "parse_mode=HTML" > /dev/null
