#!/bin/bash

echo "🚀 Starting Setup..."

# Update
sudo apt update -y

# Install NGINX
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# Install Node + PM2
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm install -g pm2

# Install Python + Flask
sudo apt install python3-flask -y

# Install PHP + Composer
sudo apt install php-fpm php-mysql php-curl php-mbstring php-xml php-bcmath unzip curl -y

cd /home/ubuntu
curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer

# Clone repo
cd /var/www
git clone https://github.com/prabool3822/devops-multi-app-deployment.git
cd devops-multi-app-deployment

# Node setup
cd node-app
npm install
pm2 start server.js --name node-app
pm2 save

# Flask setup
cd ../flask-app
pm2 start app.py --interpreter=python3 --name flask-app
pm2 save

# Laravel setup
cd ../laravel-app
composer install
cp .env.example .env
php artisan key:generate

touch database/database.sqlite
php artisan migrate

sudo chown -R www-data:www-data /var/www/devops-multi-app-deployment/laravel-app
sudo chmod -R 775 storage bootstrap/cache
sudo chmod 664 database/database.sqlite

# NGINX setup
sudo cp /var/www/devops-multi-app-deployment/nginx/site-config.conf /etc/nginx/sites-available/devops-app
sudo ln -s /etc/nginx/sites-available/devops-app /etc/nginx/sites-enabled/

sudo systemctl restart nginx
sudo systemctl restart php8.3-fpm

echo "✅ Setup Complete!"
