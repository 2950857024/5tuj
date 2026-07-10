FROM alpine:3.19

RUN apk add --no-cache \
    curl \
    bash \
    ca-certificates \
    socat \
    tzdata \
    sqlite \
    nginx \
    gettext \
    && ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime

# نصب نسخه جدید 3x-ui v3.4.2
RUN curl -L https://github.com/mhsanaei/3x-ui/releases/download/v3.4.2/x-ui-linux-amd64.tar.gz -o /tmp/x-ui.tar.gz \
    && tar -xzf /tmp/x-ui.tar.gz -C /usr/local/ \
    && rm /tmp/x-ui.tar.gz \
    && chmod +x /usr/local/x-ui/x-ui

RUN mkdir -p /etc/x-ui /var/log/x-ui /var/www/html

# کپی فایل‌ها
COPY fix-config.html /var/www/html/fix-config.html
COPY sub-link.html /var/www/html/sub-link.html
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 3000 2053 8080 2096

CMD ["/start.sh"]