#!/bin/sh

set -e

listen_port="${LISTEN_PORT:-${LISTING_PORT:-}}"

[ -z "$listen_port" ] && echo '$LISTEN_PORT undefined' && exit 1

if [ -n "${LISTING_PORT:-}" ] && [ -z "${LISTEN_PORT:-}" ]; then
    echo 'warning: LISTING_PORT is deprecated; use LISTEN_PORT instead' >&2
fi

bridge_count=0
i=1
while [ "$i" -le 20 ]; do
    eval "bridge=\${OBFS4_ADR${i}:-}"
    [ -n "$bridge" ] && bridge_count=$((bridge_count + 1))
    i=$((i + 1))
done

[ "$bridge_count" -eq 0 ] && echo 'at least one $OBFS4_ADR1..$OBFS4_ADR20 bridge is required' && exit 1

set -x

{
    sed -e "s#{SOCKS_LISTEN_ADDRESS}#${SOCKS_LISTEN_ADDRESS:-0.0.0.0}#" \
        -e "s#{LISTEN_PORT}#$listen_port#" \
        -e "s#{SOCKS_PORT_FLAGS}#${SOCKS_PORT_FLAGS:-}#" \
        /torrc.template

    i=1
    while [ "$i" -le 20 ]; do
        eval "bridge=\${OBFS4_ADR${i}:-}"
        [ -n "$bridge" ] && printf 'Bridge %s\n' "$bridge"
        i=$((i + 1))
    done

    [ -n "${EXCLUDE_NODES:-}" ] && printf 'ExcludeNodes %s\n' "$EXCLUDE_NODES"
    [ -n "${STRICT_NODES:-}" ] && printf 'StrictNodes %s\n' "$STRICT_NODES"
} >/tmp/torrc

exec "$@"
