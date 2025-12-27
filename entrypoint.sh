#!/bin/bash
set -e

if [ -z "$UUID" ]; then echo "Error: UUID missing"; exit 1; fi
if [ -z "$TUNNEL_TOKEN" ]; then echo "Error: TUNNEL_TOKEN missing"; exit 1; fi
WSPATH=${WSPATH:-/}

echo "--- Generating Configs ---"

# 生成 Sing-box 配置
sed -e "s|\$\$UUID\$\$|$UUID|g" \
    -e "s|\$\$WSPATH\$\$|$WSPATH|g" \
    /app/config.template.json > /etc/sing-box/config.json

# 🌟 生成 info.html (如果不生成，访问就是 404)
sed -e "s|\$\$UUID\$\$|$UUID|g" \
    -e "s|\$\$WSPATH\$\$|$WSPATH|g" \
    /app/info.template.html > /var/www/html/info.html

# 生成 Nginx 配置
sed -e "s|\$\$WSPATH\$\$|$WSPATH|g" \
    /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "--- Starting Services ---"
nginx
cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN" &

sleep 5
/usr/bin/sing-box run -D /var/lib/sing-box -C /etc/sing-box
