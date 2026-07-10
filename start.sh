#!/bin/bash
set -e

export NGINX_PORT=3000

mkdir -p /etc/x-ui /var/log/x-ui /var/www/html

cd /usr/local/x-ui
./x-ui setting -port 2053 -webBasePath /mikaeel/ || true

envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

nginx -t

./x-ui &
sleep 2

echo "========================================="
echo "  Service Ready!"
echo "  Panel: http://localhost:2053/mikaeel/"
echo "  Sub:   http://localhost:${NGINX_PORT}/sub/?id=txctcczehekbjlkq"
echo "========================================="

exec nginx -g "daemon off;"