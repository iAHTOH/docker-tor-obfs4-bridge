# docker: tor obfs4 bridge 🐳

Tor bridge running obfs4 obfuscation protocol on Alpine

Alpine port of https://dip.torproject.org/torproject/anti-censorship/docker-obfs4-bridge

## usage
Собираем
```sh
docker build -t iahtoh/tor-obfs4-bridge https://github.com/iAHTOH/docker-tor-obfs4-bridge.git
```

Можно выбрать свой порт прослушивания LISTING_PORT

(see `/proc/sys/net/ipv4/ip_local_port_range` for range)

```sh
ddocker run --name tor_obfs4_bridge     
    -e LISTING_PORT=9050 -p 9050:9050 \
    -e CONTACT_INFO=admin@optional.com \
     iahtoh/tor-obfs4-bridge
```
obfs4 мост задается в настройках контейнера.
add `-v tor_obfs4_bridge_data:/var/lib/tor` to keep server's identity key
when restarting the container

additionally add `--read-only --tmpfs /tmp:rw,size=4k`
to make the container's root filesystem read only

verify status of bridge at  https://metrics.torproject.org/rs.html

## further reading

https://community.torproject.org/relay/setup/bridge/
