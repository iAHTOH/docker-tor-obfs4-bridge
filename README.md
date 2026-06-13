# docker: tor obfs4 bridge 🐳

Tor bridge running obfs4 obfuscation protocol on Alpine

Alpine port of https://dip.torproject.org/torproject/anti-censorship/docker-obfs4-bridge

## usage (English)
### Build
```sh
docker build -t iahtoh/tor-obfs4-bridge https://github.com/iAHTOH/docker-tor-obfs4-bridge.git
```

### Run
Set `LISTEN_PORT` to the public SOCKS port for the bridge (the legacy `LISTING_PORT` variable still works but logs a deprecation warning).

```sh
docker run --name tor_obfs4_bridge \
  -e LISTEN_PORT=9050 \
  -p 9050:9050 iahtoh/tor-obfs4-bridge:latest
```

### Docker Compose example
```yaml
version: "3.9"
services:
  tor-obfs4:
    image: docker.io/iahtoh/tor-obfs4-bridge:latest
    restart: unless-stopped
    environment:
      - LISTEN_PORT=51822
      - OBFS4_ENABLE_ADDITIONAL_VARIABLES=1
      - OBFS4V_SocksPort=51822 IsolateClientAddr AuthenticationMethods=1
      - OBFS4V_Socks5ProxyUsername=AHTOH
      - OBFS4V_Socks5ProxyPassword=Apollon13
      - OBFS4_ADR1=obfs4 94.131.97.25:50703 ...
    ports:
      - "51822:51822"
    volumes:
      - /docker/tor_obfs4:/var/lib/tor
```

The bridge configuration is read from environment variables (see examples above); add `-v tor_obfs4_bridge_data:/var/lib/tor` to persist identity keys between restarts and `--read-only --tmpfs /tmp:rw,size=4k` if you want to lock the root filesystem.

Verify the bridge status at https://metrics.torproject.org/rs.html.

## использование (Русский)
### Сборка
```sh
docker build -t iahtoh/tor-obfs4-bridge https://github.com/iAHTOH/docker-tor-obfs4-bridge.git
```

### Запуск
Укажите `LISTEN_PORT`, чтобы задать публичный SOCKS-порт моста. Переменная `LISTING_PORT` устарела и теперь вызывает предупреждение, но пока поддерживается для обратной совместимости.

```sh
docker run --name tor_obfs4_bridge \
  -e LISTEN_PORT=9050 \
  -p 9050:9050 iahtoh/tor-obfs4-bridge:latest
```

### Пример docker-compose
```yaml
version: "3.9"
services:
  tor-obfs4:
    image: docker.io/iahtoh/tor-obfs4-bridge:latest
    restart: unless-stopped
    environment:
      - LISTEN_PORT=51822
      - OBFS4_ENABLE_ADDITIONAL_VARIABLES=1
      - OBFS4V_SocksPort=51822 IsolateClientAddr AuthenticationMethods=1
      - OBFS4V_Socks5ProxyUsername=AHTOH
      - OBFS4V_Socks5ProxyPassword=Apollon13
      - OBFS4_ADR1=obfs4 94.131.97.25:50703 ...
    ports:
      - "51822:51822"
    volumes:
      - /docker/tor_obfs4:/var/lib/tor
```

Набор переменных и мостов определяется через переменные окружения (см. примеры выше). Добавьте `-v tor_obfs4_bridge_data:/var/lib/tor`, чтобы сохранить ключи моста, и используйте `--read-only --tmpfs /tmp:rw,size=4k`, если хотите сделать файловую систему только для чтения.

Проверяйте статус моста на https://metrics.torproject.org/rs.html.
