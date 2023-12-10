#!/bin/sh

set -e

[ -z "$LISTING_PORT" ] && echo '$LISTING_PORT undefined' && exit 1


set -x

sed  -e "s#{OR_PORT}#$OR_PORT#" \
     -e "s#{LISTING_PORT}#$LISTING_PORT#" \
     -e "s#{OBFS4_ADR1}#$OBFS4_ADR1#" \
     -e "s#{OBFS4_ADR2}#$OBFS4_ADR2#" \
     -e "s#{OBFS4_ADR3}#$OBFS4_ADR3#" \
     -e "s#{OBFS4_ADR4}#$OBFS4_ADR4#" \
     /torrc.template >/tmp/torrc

exec "$@"
