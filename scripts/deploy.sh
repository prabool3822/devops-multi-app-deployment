#!/bin/bash

echo "🚀 Starting Deployment..."

cd /var/www/devops-multi-app-deployment || exit

# Pull latest code
git pull origin main

# Node
cd node-app
npm install
pm2 restart node-app

# Flask
cd ../flask-app
pm2 restart flask-app

# Laravel
cd ../laravel-app
composer install --no-interaction --prefer-dist --optimize-autoloader

php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache

sudo chown -R www-data:www-data /var/www/devops-multi-app-deployment/laravel-app
sudo chmod -R 775 storage bootstrap/cache

# Restart services
sudo systemctl restart nginx
sudo systemctl restart php8.3-fpm

echo "✅ Deployment Done!"
