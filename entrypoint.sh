#!/bin/sh
set -e

echo "======================================"
echo " Запуск Tor + obfs4 + 3proxy"
echo "======================================"

# --- проверки ---
[ -z "$PROXY_USER" ] && { echo "NO PROXY_USER"; exit 1; }
[ -z "$PROXY_PASS" ] && { echo "NO PROXY_PASS"; exit 1; }

echo "User: $PROXY_USER"

# --- мосты ---
bridge_list=""
for i in 1 2 3 4; do
    eval "b=\${OBFS4_ADR${i}:-}"
    [ -n "$b" ] && bridge_list="$bridge_list
Bridge $(echo "$b" | sed 's/^Bridge //')"
done

[ -z "$bridge_list" ] && { echo "NO BRIDGES"; exit 1; }

echo "Bridges loaded"

# --- torrc ---
cat /torrc.template > /tmp/torrc

printf "%s\n" "$bridge_list" >> /tmp/torrc

[ -n "$EXCLUDE_NODES" ] && echo "ExcludeNodes $EXCLUDE_NODES" >> /tmp/torrc
[ -n "$STRICT_NODES" ] && echo "StrictNodes $STRICT_NODES" >> /tmp/torrc

echo "SafeLogging 0" >> /tmp/torrc

echo "Tor config ready"

# --- 3proxy config ---
cat > /tmp/3proxy.cfg <<EOF
auth strong

users ${PROXY_USER}:CL:${PROXY_PASS}
allow ${PROXY_USER}

parent 1000 socks5+ 127.0.0.1 9050

socks -p51822 -a
EOF

echo "3proxy config ready"

# --- Tor start ---
echo "Starting Tor..."
tor -f /tmp/torrc &
TOR_PID=$!

# --- wait Tor SOCKS ---
echo "Waiting Tor SOCKS..."
i=0
while ! nc -z 127.0.0.1 9050 >/dev/null 2>&1; do
    i=$((i+1))
    [ "$i" -gt 30 ] && {
        echo "Tor failed to start"
        kill $TOR_PID
        exit 1
    }
    sleep 1
done

echo "Tor ready"

# --- остановка Tor при завершении контейнера ---
trap 'kill $TOR_PID 2>/dev/null || true' TERM INT

# --- основной процесс ---
echo "Starting 3proxy..."
exec 3proxy /tmp/3proxy.cfg