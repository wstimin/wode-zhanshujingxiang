#!/bin/bash
set -e

# 检查变量
if [ -z "$UUID" ]; then
  echo "Error: UUID 环境变量未设置！"
  exit 1
fi
if [ -z "$TUNNEL_TOKEN" ]; then
  echo "Error: TUNNEL_TOKEN 环境变量未设置！"
  exit 1
fi
WSPATH=${WSPATH:-/}

echo "--- 1. 生成配置文件 ---"

# ⚠️ 修正点：从 /app/config.template.json 读取模板
# 生成到 /etc/sing-box/config.json (这是 Sing-box 唯一应该读取的文件)
sed -e "s|\$\$UUID\$\$|$UUID|g" \
    -e "s|\$\$WSPATH\$\$|$WSPATH|g" \
    /app/config.template.json > /etc/sing-box/config.json

# 替换 Nginx 配置
sed -e "s|\$\$WSPATH\$\$|$WSPATH|g" \
    /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "--- 2. 启动 Nginx (伪装前台) ---"
nginx

echo "--- 3. 启动 Cloudflared 隧道 ---"
cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN" &

# 等待隧道建立
sleep 5

echo "--- 4. 启动 Sing-box (核心节点) ---"
/usr/bin/sing-box run -D /var/lib/sing-box -C /etc/sing-box
