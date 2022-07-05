#FROM debian:sid

#RUN    apt-get update 
#RUN    apt-get install -y tor 
#RUN    apt-get install -y obfs4proxy 
#RUN    apt-get clean
    
FROM alpine:edge
RUN apk add --no-cache tor && \
    apk add --no-cache obfs4proxy --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
      

#RUN apk add --no-cache \
#        less \
#        man-db \
#        tor-doc=$TOR_PACKAGE_VERSION
#ENV PAGER=less


ENV LISTING_PORT="5090"
ENV OBFS4_ADR1="obfs4 23.234.201.138:4444 6655082E9593CEE926000AE9BFF2DE7544C99DD7 cert=UwwqAYLgjaYxtp7A02glyZsKOYAwXL5xy42qtXNHfqiR5xinK8y+jN+sRZglTvHHmlVEbA iat-mode=0"
ENV OBFS4_ADR2="obfs4 217.160.47.23:80 6A6575D92D25E070790E58DB657001BC03D17113 cert=OFP48a6Oo9nxuDZ0PCqiTam/fV3RxQuLhLcgzmSczm0MzjuTLfwfRs5jXx99xklJ55OYQA iat-mode=0"
ENV OBFS4_ADR3="obfs4 135.181.213.202:9832 D69FF88AAB6C30E10DA99CB614A88321F6A496A2 cert=XdwUIOSRIOWZz9k9gyX6v4aKBj6rN4Xi1ADiM/8wJqTZLFUqy+Mc2BIzzxfBdeDyJKjOBQ iat-mode=0"
ENV OBFS4_ADR4="obfs4 158.247.207.151:443 6170ADBBB6C1859A8E7E4416BB8AB3AF471AE47F cert=Od4izlwLnXcq7LMSOJtnZLtklaUn+X+gPcBwN7RUEkk9rqxRRYNHW7as8g6+jheDsazxAQ iat-mode=0"

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
