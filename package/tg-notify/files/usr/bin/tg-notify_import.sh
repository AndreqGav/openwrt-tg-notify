#!/bin/sh

LEASES="/tmp/dhcp.leases"
HANDLER="/etc/hotplug.d/dhcp/90-tg-notify"

[ -r "$LEASES" ] || {
    logger -t tg-notify "DHCP leases not found: $LEASES"
    exit 1
}

[ -f "$HANDLER" ] || {
    logger -t tg-notify "DHCP handler not found: $HANDLER"
    exit 1
}

now="$(date +%s)"
count=0

while read -r expires mac ip hostname clientid; do
    case "$expires" in ''|*[!0-9]*) continue ;; esac
    [ "$expires" -eq 0 ] || [ "$expires" -gt "$now" ] || continue
    case "$ip" in *:*) continue ;; esac
    [ -n "$mac" ] && [ -n "$ip" ] || continue
    [ "$hostname" = '*' ] && hostname=

    ACTION=add MACADDR="$mac" IPADDR="$ip" HOSTNAME="$hostname" \
        sh "$HANDLER" </dev/null

    count=$((count + 1))
done < "$LEASES"

logger -t tg-notify "Processed DHCP clients: $count"
