FROM alpine:latest
WORKDIR /app

# 安装基础工具 和 Nginx
RUN apk add --no-cache bash curl wget ca-certificates jq tzdata nginx

# --- 安装 Sing-box ---
RUN wget -O sing-box.tar.gz https://github.com/SagerNet/sing-box/releases/download/v1.8.11/sing-box-1.8.11-linux-amd64.tar.gz && \
    tar -zxvf sing-box.tar.gz && \
    mv sing-box-*/sing-box /usr/bin/sing-box && \
    chmod +x /usr/bin/sing-box && \
    rm -rf sing-box.tar.gz sing-box-* && \
    mkdir -p /etc/sing-box /var/lib/sing-box

# --- 安装 Cloudflared ---
RUN wget -O /usr/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/bin/cloudflared

# --- 复制文件 ---
# 1. 复制网页文件
COPY index.html /var/www/html/index.html
# 2. 复制 Nginx 配置模板
COPY nginx.conf /etc/nginx/nginx.conf.template
# 3. ⚠️ 修正点：把模板放在 /app 下，而不是 /etc/sing-box
COPY config.template.json /app/config.template.json
# 4. 复制启动脚本
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
# 创建 Nginx 运行目录
RUN mkdir -p /run/nginx

ENTRYPOINT ["/entrypoint.sh"]
