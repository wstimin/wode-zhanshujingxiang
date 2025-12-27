#!/bin/bash
set -e

if [ -z "$UUID" ]; then echo "Error: UUID missing"; exit 1; fi
if [ -z "$TUNNEL_TOKEN" ]; then echo "Error: TUNNEL_TOKEN missing"; exit 1; fi
WSPATH=${WSPATH:-/}

echo "--- 1. Generating Configs ---"

# Sing-box 配置
sed -e "s|\$\$UUID\$\$|$UUID|g" \
    -e "s|\$\$WSPATH\$\$|$WSPATH|g" \
    /app/config.template.json > /etc/sing-box/config.json

# 🌟 新增：生成 info.html (填入 UUID 和 Path)
sed -e "s|\$\$UUID\$\$|$UUID|g" \
    -e "s|\$\$WSPATH\$\$|$WSPATH|g" \
    /app/info.template.html > /var/www/html/info.html

# Nginx 配置
sed -e "s|\$\$WSPATH\$\$|$WSPATH|g" \
    /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "--- 2. Starting Services ---"
nginx
cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN" &

sleep 5
/usr/bin/sing-box run -D /var/lib/sing-box -C /etc/sing-box
