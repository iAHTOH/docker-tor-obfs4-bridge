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
ENV OBFS4_ADR1="obfs4 178.254.12.143:1025 393A474F44A3D275CD84DCBB823BE46FE561613C cert=f+w6eAyMR+qpFSfECYXTkLK+bS4gVydU55wK2tZK+zmXgCdTs0aIJl/aF4aExC+UWo3/PQ iat-mode=0"
ENV OBFS4_ADR2="obfs4 213.239.209.42:55112 D00BEBE4863D869D4E8B6B6A84154988EEE10CEA cert=XYXHWnakHj9UiSQRhbWbKvSv1rBq8tnxTFhwn668e3pZS+Y/ROXu8wXwDMwHzeEE9d6nRg iat-mode=0"
ENV OBFS4_ADR3="obfs4 51.210.147.13:49263 02FD535BFCF5FCC210FBFDE39795F47603C77213 cert=s8pFB9cDcZdD8OtwxxfaMfgooQHB3QcePYH/QEE+2pFoZdnwI9lFe8TNfVqOUVp1G8XeJQ iat-mode=0"
ENV OBFS4_ADR4="obfs4 46.226.104.87:43587 C004E895FFC39F2493693A4CE9AFB038E2524EE8 cert=vXbukpKDvN7mJZlDiRLKV+svtg0fEng83SxWUSU7EQHe++FSTTpAv8KR/DHNe0zemEZXZw iat-mode=0"

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
