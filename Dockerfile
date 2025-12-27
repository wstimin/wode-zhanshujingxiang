FROM alpine:latest
WORKDIR /app

# 安装基础工具 + Nginx
RUN apk add --no-cache bash curl wget ca-certificates jq tzdata nginx

# 安装 Sing-box (使用官方 Release)
RUN wget -O sing-box.tar.gz https://github.com/SagerNet/sing-box/releases/download/v1.8.11/sing-box-1.8.11-linux-amd64.tar.gz && \
    tar -zxvf sing-box.tar.gz && \
    mv sing-box-*/sing-box /usr/bin/sing-box && \
    chmod +x /usr/bin/sing-box && \
    rm -rf sing-box.tar.gz sing-box-* && \
    mkdir -p /etc/sing-box /var/lib/sing-box

# 安装 Cloudflared
RUN wget -O /usr/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/bin/cloudflared

# 复制文件
COPY index.html /var/www/html/index.html
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY config.template.json /etc/sing-box/config.template.json
COPY entrypoint.sh /entrypoint.sh

# 权限与目录
RUN chmod +x /entrypoint.sh && mkdir -p /run/nginx

ENTRYPOINT ["/entrypoint.sh"]
