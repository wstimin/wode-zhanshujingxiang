#!/bin/bash
set -e

# 检查变量
if [ -z "$UUID" ]; then echo "Error: UUID is missing"; exit 1; fi
if [ -z "$TUNNEL_TOKEN" ]; then echo "Error: TUNNEL_TOKEN is missing"; exit 1; fi
WSPATH=${WSPATH:-/}

echo "--- Generating Configs ---"
# 1. 配置 Sing-box (填入 UUID 和 Path)
sed -e "s|\$\$UUID\$\$|$UUID|g" \
    -e "s|\$\$WSPATH\$\$|$WSPATH|g" \
    /etc/sing-box/config.template.json > /etc/sing-box/config.json

# 2. 配置 Nginx (填入 Path)
sed -e "s|\$\$WSPATH\$\$|$WSPATH|g" \
    /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "--- Starting Services ---"
# 启动 Nginx (后台)
nginx
# 启动 Tunnel (后台)
cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN" &

sleep 5
# 启动 Sing-box (前台)
/usr/bin/sing-box run -D /var/lib/sing-box -C /etc/sing-box
