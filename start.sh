#!/bin/bash
set -e

echo "========================================="
echo "  Starting X-UI v3.4.2 + nginx"
echo "========================================="

export NGINX_PORT=3000

# ایجاد دایرکتوری‌های لازم
mkdir -p /etc/x-ui /var/log/x-ui /var/www/html

# کانفیگ X-UI
cd /usr/local/x-ui
echo "Configuring X-UI panel..."
./x-ui setting -port 2053 -webBasePath /mikaeel/ || true

# ست کردن پسورد پیش‌فرض (اگر نیاز باشد)
./x-ui setting -username admin -password admin || true

# کانفیگ nginx
echo "Generating nginx configuration..."
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# تست nginx
nginx -t

# شروع X-UI در background
echo "Starting X-UI..."
./x-ui &
X_UI_PID=$!

sleep 3

echo "========================================="
echo "  Service Status:"
echo "  - Panel:   http://localhost:2053/mikaeel/"
echo "  - Fix:     http://localhost:${NGINX_PORT}/fix-config"
echo "  - Sub:     http://localhost:${NGINX_PORT}/sub/?email=ufa7zpn9"
echo "========================================="

# شروع nginx
exec nginx -g "daemon off;"