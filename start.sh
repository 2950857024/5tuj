#!/bin/bash
set -e

echo "========================================="
echo "  Starting X-UI + nginx reverse proxy"
echo "========================================="

export NGINX_PORT=3000

# Create necessary directories
echo "Creating directories..."
mkdir -p /etc/x-ui/subscriptions
mkdir -p /var/log/x-ui
mkdir -p /var/www/html

# Create a default test subscription
echo "Creating default subscription..."
cat > /etc/x-ui/subscriptions/test-sub << 'EOF'
vless://5d88e790-a966-4a50-a34d-90acb6129313@5tuj-production.up.railway.app:8080?encryption=none&security=none&type=ws&host=5tuj-production.up.railway.app&path=/#test
EOF

# Create your actual subscription
cat > /etc/x-ui/subscriptions/vless-5d88e790-a966-4a50-a34d-90acb6129313 << 'EOF'
vless://5d88e790-a966-4a50-a34d-90acb6129313@5tuj-production.up.railway.app:8080?encryption=none&security=none&type=ws&host=5tuj-production.up.railway.app&path=/#5tuj-production
EOF

# Set proper permissions
chmod 644 /etc/x-ui/subscriptions/*

# Configure X-UI
cd /usr/local/x-ui
echo "Configuring X-UI panel..."
./x-ui setting -port 2053 -webBasePath /mikaeel/ || true

# Generate nginx config
echo "Generating nginx configuration..."
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Test nginx configuration
echo "Testing nginx configuration..."
nginx -t

# Start X-UI in background
echo "Starting X-UI..."
./x-ui &
X_UI_PID=$!

# Wait for X-UI to start
sleep 3

# Start nginx
echo "========================================="
echo "  Service Status:"
echo "  - X-UI:      http://localhost:2053/mikaeel/"
echo "  - Fix Config: http://localhost:${NGINX_PORT}/fix-config"
echo "  - Subscribe:  http://localhost:${NGINX_PORT}/sub/"
echo "  - Raw:        http://localhost:${NGINX_PORT}/rawsub/test-sub"
echo "========================================="
echo "Starting nginx on port ${NGINX_PORT}..."

# Start nginx in foreground
exec nginx -g "daemon off;"