#!/bin/bash
set -e

echo "========================================="
echo "  Starting X-UI v3.4.2 + nginx"
echo "========================================="

export NGINX_PORT=3000

# Create directories
mkdir -p /etc/x-ui /var/log/x-ui /var/www/html

# Configure X-UI
cd /usr/local/x-ui
echo "Configuring X-UI panel..."
./x-ui setting -port 2053 -webBasePath /mikaeel/ || true
./x-ui setting -username admin -password admin || true

# Generate nginx config
echo "Generating nginx configuration..."
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Test nginx
nginx -t

# Start X-UI in background
echo "Starting X-UI..."
./x-ui &
X_UI_PID=$!

sleep 3

echo "========================================="
echo "  Service Ready!"
echo "  Panel:  http://localhost:2053/mikaeel/"
echo "  Sub:    http://localhost:${NGINX_PORT}/sub/?id=opukizbfvt3semro"
echo "  Fix:    http://localhost:${NGINX_PORT}/fix-config"
echo "========================================="

# Start nginx
exec nginx -g "daemon off;"