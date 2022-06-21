# https://pkgs.alpinelinux.org/packages?name=obfs4proxy&arch=x86_64
FROM alpine:edge


RUN apk add --no-cache tor && \
    apk add --no-cache obfs4proxy --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
      

#RUN apk add --no-cache \
#        less \
#        man-db \
#        tor-doc=$TOR_PACKAGE_VERSION
#ENV PAGER=less


ENV LISTING_PORT="5090"
ENV OBFS4_ADR1="obfs4 146.59.242.94:41695 E65567CEB2B2C944272897A9E6FB5FD88BEB538D cert=S848VVq1uMaDhtB+ZfuvbL8uyT8BY/t68ckjzzM516r7Ijr62ax+wwn0KzjuqmBu+zVOKw iat-mode=0"
ENV OBFS4_ADR2="obfs4 206.189.141.107:29914 00122146FB0CA37DAA1694947EB307CE39FED11C cert=6f8Ll67R+j23LwwQeERQgCUSRzSpjSJlXNANUq+Ix5oigZTa5itKbu8CMigZu+wF3ChjXA iat-mode=0"
ENV OBFS4_ADR3="obfs4 23.234.201.138:4444 6655082E9593CEE926000AE9BFF2DE7544C99DD7 cert=UwwqAYLgjaYxtp7A02glyZsKOYAwXL5xy42qtXNHfqiR5xinK8y+jN+sRZglTvHHmlVEbA iat-mode=0"
ENV OBFS4_ADR4="obfs4 65.21.251.183:443 EC08D3C97329FC4D23395CB323878E6035116556 cert=tGSSzwz9w8PelECcWE6cvTsA1Trb6HiV/NMXfSeY0EA8Rzmj7/SorXlTtKkZ7Bl6G1n1Pg iat-mode=0"
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
