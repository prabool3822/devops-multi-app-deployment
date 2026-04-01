#!/bin/bash

echo "🚀 Starting Deployment..."

cd /var/www/devops-multi-app-deployment

# Pull latest code
git pull origin main

# -------------------------------
# STATIC SITE
# -------------------------------
echo "🌐 Updating Static Site..."
sudo cp -r static-site/* /var/www/html/

# -------------------------------
# NODE APP
# -------------------------------
echo "⚙️ Updating Node App..."
cd node-app
npm install
pm2 restart node-app

# -------------------------------
# FLASK APP
# -------------------------------
echo "🐍 Updating Flask App..."
cd ../flask-app
pip3 install -r requirements.txt
pm2 restart flask-app

# -------------------------------
# LARAVEL APP
# -------------------------------
echo "🔥 Updating Laravel..."
cd ../laravel-app

composer install --no-interaction --prefer-dist

php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache

pm2 restart laravel-app

# -------------------------------
# NGINX RELOAD
# -------------------------------
sudo systemctl reload nginx

echo "✅ Deployment Completed!"
