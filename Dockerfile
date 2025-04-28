#FROM debian:sid

#RUN    apt-get update 
#RUN    apt-get install -y tor 
#RUN    apt-get install -y obfs4proxy 
#RUN    apt-get clean
    
FROM alpine:edge
RUN apk add --no-cache tor && \
    #apk add --no-cache obfs4proxy --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
    #apk add --no-cache lyrebird --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
    apk add --no-cache lyrebird --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/x86_64/
      

#RUN apk add --no-cache \
#        less \
#        man-db \
#        tor-doc=$TOR_PACKAGE_VERSION
#ENV PAGER=less 

ENV OR_PORT=
ENV LISTING_PORT="5090"
ENV OBFS4_ADR1="obfs4 172.26.7.165:995 1DA67FB04C8125EEDD0C8BA16A0D13932F20DBD8 cert=BFesPfPCzpHRfAFRHSS63/m8rzC7S1977Yz/y5RLctf7gt6DGsk1Ge7Mvh0DrdW6H9LKFQ iat-mode=0"
ENV OBFS4_ADR2="obfs4 185.92.222.151:4051 01408A213812D3FC7A2A744F70903D044AF697CA cert=rEimVQBvn//XaRZMcZiRHuWKTjPG3v/aEtJrDNKGY8bXVEVDTn90WVP/NQquwI2t2eJJOw iat-mode=0"
ENV OBFS4_ADR3="obfs4 91.99.48.143:1345 A68E506DAC94E27A55A3EDEDD13D3643A1DF55A6 cert=fw5gRgN8D9hjK6QYxwBnNy/uoiZjPvBCcsIf4NsNfEHv6W6UcMGvbNr7h6NvaBv0GKiwMw iat-mode=0"
ENV OBFS4_ADR4="obfs4 91.99.78.16:7237 4222D2CFB5010ECB9F7C9B98E3CBEAF42D2948CC cert=mMbciV8y5ibS5za7KETROHnrS6tzvJvh3J2U03gYv/659PVTrjFhTHXmYsUq5fcZZ5BoHQ iat-mode=0"

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
