#!/bin/bash

echo "🚀 Starting Full Setup..."

# -------------------------------
# SYSTEM SETUP
# -------------------------------
sudo apt update -y
sudo apt install -y nginx git curl unzip software-properties-common

# -------------------------------
# NODE + PM2
# -------------------------------
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g pm2

# -------------------------------
# PYTHON + FLASK
# -------------------------------
sudo apt install -y python3 python3-pip
pip3 install flask

# -------------------------------
# PHP + LARAVEL DEPENDENCIES
# -------------------------------
sudo apt install -y php php-fpm php-cli php-mbstring php-xml php-curl php-sqlite3

# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# -------------------------------
# CLONE PROJECT
# -------------------------------
cd /var/www
sudo rm -rf devops-multi-app-deployment
sudo git clone https://github.com/prabool3822/devops-multi-app-deployment.git
cd devops-multi-app-deployment

# -------------------------------
# STATIC SITE
# -------------------------------
echo "🌐 Setting up Static Site..."
sudo rm -rf /var/www/html/*
sudo cp -r static-site/* /var/www/html/

# -------------------------------
# NODE APP
# -------------------------------
echo "⚙️ Setting up Node App..."
cd node-app
npm install
pm2 start server.js --name node-app

# -------------------------------
# FLASK APP
# -------------------------------
echo "🐍 Setting up Flask App..."
cd ../flask-app
pip3 install -r requirements.txt
pm2 start app.py --name flask-app --interpreter python3

# -------------------------------
# LARAVEL APP
# -------------------------------
echo "🔥 Setting up Laravel..."
cd ../laravel-app

# Create env
cp .env.example .env

# Install dependencies
composer install --no-interaction --prefer-dist

# Generate key
php artisan key:generate

# Create database
touch database/database.sqlite

# Permissions
sudo chown -R www-data:www-data storage bootstrap/cache database
sudo chmod -R 775 storage bootstrap/cache database

# Run migrations
php artisan migrate --force

# Start Laravel
pm2 start "php artisan serve --host=0.0.0.0 --port=8000" --name laravel-app

# -------------------------------
# NGINX CONFIG
# -------------------------------
echo "🌍 Configuring NGINX..."
sudo cp ../nginx/site-config.conf /etc/nginx/sites-available/default

sudo nginx -t
sudo systemctl restart nginx

# -------------------------------
# SAVE PM2
# -------------------------------
pm2 save
pm2 startup systemd -u ubuntu --hp /home/ubuntu

echo "✅ FULL SETUP COMPLETED!"
