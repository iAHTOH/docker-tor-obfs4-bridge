# Базовый образ Alpine Linux
ARG ALPINE_VERSION=3.24

FROM docker.io/alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION
ARG TOR_PACKAGE_VERSION=0.4.9.9-r0
ARG LYREBIRD_PACKAGE_VERSION=0.8.1-r5

# Устанавливаем пакеты:
# - tor       : клиент Tor
# - lyrebird  : obfs4 транспорт
# - 3proxy    : SOCKS5 proxy с авторизацией (из edge/testing)
RUN apk add --no-cache \
        --repository "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/community" \
        --repository "https://dl-cdn.alpinelinux.org/alpine/edge/testing" \
        tor=$TOR_PACKAGE_VERSION \
        lyrebird=$LYREBIRD_PACKAGE_VERSION \
        3proxy

# Логин для SOCKS5
ENV PROXY_USER=

# Пароль для SOCKS5
ENV PROXY_PASS=

# Не использовать узлы из RU / BY / KZ
ENV EXCLUDE_NODES={ru},{by},{kz}

# Жёсткое соблюдение правил исключения
ENV STRICT_NODES=1

# До 4 obfs4 мостов
ENV OBFS4_ADR1=
ENV OBFS4_ADR2=
ENV OBFS4_ADR3=
ENV OBFS4_ADR4=

# Копируем конфиг и entrypoint
COPY torrc.template entrypoint.sh /

# Права на выполнение
RUN chmod a+rx /torrc.template /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /var/lib/tor