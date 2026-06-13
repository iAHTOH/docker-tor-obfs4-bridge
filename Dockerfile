ARG ALPINE_VERSION=3.24
FROM docker.io/alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION
ARG TOR_PACKAGE_VERSION=0.4.9.9-r0
ARG LYREBIRD_PACKAGE_VERSION=0.8.1-r5
RUN apk add --no-cache \
        --repository "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/community" \
        tor=$TOR_PACKAGE_VERSION \
        lyrebird=$LYREBIRD_PACKAGE_VERSION

ENV LISTEN_PORT=9050
ENV LISTING_PORT=
ENV SOCKS_LISTEN_ADDRESS=0.0.0.0
ENV SOCKS_PORT_FLAGS=
ENV EXCLUDE_NODES=
ENV STRICT_NODES=
ENV OBFS4_ADR1=
ENV OBFS4_ADR2=
ENV OBFS4_ADR3=
ENV OBFS4_ADR4=

COPY torrc.template entrypoint.sh /
RUN chmod -c a+rX /torrc.template /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

USER tor
VOLUME /var/lib/tor
CMD ["tor", "-f", "/tmp/torrc"]

# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md
ARG REVISION=
LABEL org.opencontainers.image.title="Tor SOCKS proxy over obfs4 bridges" \
    org.opencontainers.image.source="https://github.com/iAHTOH/docker-tor-obfs4-bridge" \
    org.opencontainers.image.revision="$REVISION"
