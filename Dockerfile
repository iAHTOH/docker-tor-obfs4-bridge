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
ENV OBFS4_ADR1="obfs4 206.189.141.107:29914 00122146FB0CA37DAA1694947EB307CE39FED11C cert=6f8Ll67R+j23LwwQeERQgCUSRzSpjSJlXNANUq+Ix5oigZTa5itKbu8CMigZu+wF3ChjXA iat-mode=0"
ENV OBFS4_ADR2="obfs4 23.234.201.138:4444 6655082E9593CEE926000AE9BFF2DE7544C99DD7 cert=UwwqAYLgjaYxtp7A02glyZsKOYAwXL5xy42qtXNHfqiR5xinK8y+jN+sRZglTvHHmlVEbA iat-mode=0"
ENV OBFS4_ADR3="obfs4 65.108.147.165:9806 SCB7FE57194C177AC23771FFA992AB18F3EFA8FCE cert=4fGbPOdSjQqrMoAZVJa2kXDoUobqMpxEfA0CN2lJnsZQl5i5rA89CsUpkkZ8QP9Qy0q1Wg iat-mode=0"
ENV OBFS4_ADR4="obfs4 65.108.89.13:5913 707E6B254D8101831CC05BA268AA9AB02528F03B cert=oZAR+1IgFvqvBQfZD6fVaajKkr1OtTkJqqlCsJQVFCWsfI35RRA2PVkGKPUUeWkWTkmzNg iat-mode=0"
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
