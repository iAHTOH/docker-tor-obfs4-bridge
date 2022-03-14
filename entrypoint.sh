#!/bin/sh

set -e

[ -z "$LISTING_PORT" ] && echo '$LISTING_PORT undefined' && exit 1


set -x

sed -e "s#{LISTING_PORT}#$LISTING_PORT#" \
    -e "s#{OBFS4_ADR}#$OBFS4_ADR#" \
    -e "s#{CONTACT_INFO}#$CONTACT_INFO#" \
    /torrc.template >/tmp/torrc

exec "$@"
