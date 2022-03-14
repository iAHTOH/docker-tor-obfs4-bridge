# https://pkgs.alpinelinux.org/packages?name=obfs4proxy&arch=x86_64
FROM docker.io/alpine:3.15.0

ARG TOR_PACKAGE_VERSION=0.4.6.9-r0
ARG OBFS4PROXY_PACKAGE_VERSION=0.0.11-r4
RUN apk add --no-cache tor=$TOR_PACKAGE_VERSION \
    && apk add --no-cache obfs4proxy=$OBFS4PROXY_PACKAGE_VERSION \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing

#RUN apk add --no-cache \
#        less \
#        man-db \
#        tor-doc=$TOR_PACKAGE_VERSION
#ENV PAGER=less


ENV LISTING_PORT="5090"
ENV OBFS4_ADR="obfs4 207.148.108.221:443 7259F29EC35E385B25D1DD56A3B39B76BBE63940 cert=aMu33DOPGFQsjgLZ7JtKB6Eysn9kaN4ubcWbi2zsO+rAORC1eKDrDiGqXqkJD8ZLgY25QA iat-mode=0"
ENV CONTACT_INFO="admin@optional.com"
ENV TOR_LOGIN="admin"
ENV TOR_PASS="admin"
COPY torrc.template entrypoint.sh /
RUN chmod -c a+rX /torrc.template /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

USER tor
VOLUME /var/lib/tor
CMD ["tor", "-f", "/tmp/torrc"]

# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md
ARG REVISION=
LABEL org.opencontainers.image.title="tor bridge providing obfs4 obfuscation protocol test" \
    org.opencontainers.image.source="https://github.com/iAHTOH/docker-tor-obfs4-bridge" \
    org.opencontainers.image.revision="$REVISION"
