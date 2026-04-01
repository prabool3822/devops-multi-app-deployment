# 🚀 Multi-App Deployment on AWS EC2 using NGINX (DevOps Project)

---

## 📌 Project Overview

This project demonstrates how to deploy and manage multiple backend applications on a single AWS EC2 instance using **NGINX as a reverse proxy**.

The goal was to simulate a real-world production-like environment where multiple services run together and are accessed through a unified entry point.

---

## 🧠 What This Project Proves

* Ability to configure and manage Linux servers
* Understanding of reverse proxy architecture
* Deployment of multiple backend technologies
* Debugging real-world issues (permissions, routing, services)
* Difference between development vs production setups

---

## 🏗️ Architecture

```
Client (Browser)
       ↓
   NGINX (Port 80)
       ↓
 ┌───────────────┬───────────────┬───────────────┐
 │               │               │               │
Static Site   Node.js API     Flask App     Laravel App
 (HTML)        (PM2:3000)     (PM2:5000)    (PHP-FPM)
```

---

## 🌐 Routing

| Path       | Service           |
| ---------- | ----------------- |
| `/`        | Static Website    |
| `/api`     | Node.js (Express) |
| `/python`  | Flask             |
| `/laravel` | Laravel           |

---

## 🛠️ Tech Stack

* NGINX (Reverse Proxy)
* Node.js (Express)
* Flask (Python)
* Laravel (PHP)
* PHP-FPM
* PM2 (Process Manager)
* AWS EC2 (Ubuntu)

---

## ⚙️ Setup & Deployment Steps

### 1. Server Setup

```bash
sudo apt update
sudo apt install nginx
```

---

### 2. Node.js Setup

```bash
npm install express
pm2 start server.js
pm2 save
pm2 startup
```

---

### 3. Flask Setup

```bash
sudo apt install python3-flask
pm2 start app.py
```

---

### 4. Laravel Setup

```bash
composer install
cp .env.example .env
php artisan key:generate
touch database/database.sqlite
php artisan migrate
```

---

### 5. NGINX Configuration

Example:

```nginx
location /api/ {
    proxy_pass http://127.0.0.1:3000/;
}

location /python/ {
    proxy_pass http://127.0.0.1:5000/;
}

location /laravel/ {
    alias /var/www/laravel-app/public/;
    try_files $uri $uri/ /index.php?$query_string;
}
```

---

## ⚠️ Challenges Faced & Solutions

### 🔴 1. Laravel Permission Denied (logs & storage)

**Error:**

```
Permission denied: storage/logs/laravel.log
```

**Solution:**

```bash
sudo chown -R www-data:www-data /var/www/laravel-app
sudo chmod -R 775 storage bootstrap/cache
```

---

### 🔴 2. SQLite Readonly Database

**Error:**

```
attempt to write a readonly database
```

**Solution:**

```bash
chmod 775 database
chmod 664 database/database.sqlite
```

---

### 🔴 3. Missing Dependencies (Laravel)

**Error:**

```
vendor/autoload.php missing
```

**Solution:**

```bash
composer install
```

---

### 🔴 4. NGINX 404 Error (Laravel)

**Cause:**
Used `root` instead of `alias`

**Fix:**

```nginx
alias /var/www/laravel-app/public/;
```

---

### 🔴 5. Flask Installation Error (PEP 668)

**Error:**

```
externally-managed-environment
```

**Solution:**

```bash
sudo apt install python3-flask
```

---

### 🔴 6. Apache Conflict

**Problem:**
Apache + NGINX both using port 80

**Fix:**

```bash
sudo systemctl stop apache2
sudo systemctl disable apache2
```

---

## 🔐 Permissions Learning

| Command | Meaning            |
| ------- | ------------------ |
| `chown` | Change owner       |
| `chmod` | Change permissions |

---

## 🚀 Production Improvements (Next Steps)

* Replace Flask with Gunicorn
* Replace SQLite with MySQL/PostgreSQL
* Use Docker for containerization
* Add HTTPS using SSL (Let's Encrypt)
* Use subdomains instead of paths

---

## 📸 Screenshots (Optional)

(Add screenshots of working apps here)

---

## 📂 Recommended Repository Structure

```
devops-multi-app-deployment/
│
├── README.md
├── nginx/
│   └── site-config.conf
├── node-app/
├── flask-app/
├── laravel-app/
├── scripts/
└── docs/
```

---

## ❗ Important Notes

* `.env` files are not pushed for security
* `node_modules/` and `vendor/` are excluded
* This is a learning + demonstration project

---

## 🧠 Key Takeaways

* Learned reverse proxy architecture
* Understood Linux permissions deeply
* Experienced real deployment errors
* Built a production-like multi-service system

---

## 📌 Final Thought

This project reflects **hands-on DevOps learning through real problems and solutions**, not just theory.

---

## ⭐ If you found this useful

Give this repo a ⭐ and feel free to fork or improve it!
