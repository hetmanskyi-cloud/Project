#!/bin/bash

# --- System update and required packages installation ---
sudo apt update && sudo apt upgrade -y
sudo apt install -y nginx mysql-client php-fpm php-mysql php-xml php-mbstring php-curl php-redis unzip || {
  echo "Package installation failed. Please check the connection and package availability."
  exit 1
}

# --- Download and install WordPress ---
cd /tmp || exit
curl -O https://wordpress.org/latest.zip
unzip latest.zip
sudo mv wordpress /var/www/html/wordpress

# Set permissions for WordPress
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 750 /var/www/html/wordpress

# Create WordPress configuration
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# --- Set environment variables for database and Redis ---
DB_NAME="${DB_NAME:-default_db_name}"
DB_USER="${DB_USER:-default_db_user}"
DB_PASSWORD="${DB_PASSWORD:-default_db_password}"
DB_HOST="${DB_HOST:-default_rds_host_endpoint}"

REDIS_HOST="${REDIS_HOST:-default_redis_host}"
REDIS_PORT="${REDIS_PORT:-6379}"

# Configure wp-config.php for database connection
sudo sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/localhost/$DB_HOST/" /var/www/html/wordpress/wp-config.php

# Add Redis configuration to wp-config.php
sudo tee -a /var/www/html/wordpress/wp-config.php > /dev/null <<EOL
# Redis configuration
define('WP_REDIS_HOST', '$REDIS_HOST');
define('WP_REDIS_PORT', $REDIS_PORT);
define('WP_CACHE', true);
EOL

# --- Automatically detect the PHP-FPM socket path ---
PHP_FPM_SOCK=$(find /run/php/ -name "php*-fpm.sock" | head -n 1)

# --- Configure Nginx for WordPress ---
sudo tee /etc/nginx/sites-available/wordpress > /dev/null <<EOL
server {
    listen 80 default_server;
    server_name _;

    root /var/www/html/wordpress;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:$PHP_FPM_SOCK;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL

# Enable Nginx configuration and restart service
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl restart nginx

# --- Enable Nginx and PHP-FPM to start on boot ---
sudo systemctl enable nginx
sudo systemctl enable php8.3-fpm
