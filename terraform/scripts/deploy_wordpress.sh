#!/bin/bash

# --- Log file setup --- #

LOG_FILE="/var/log/wordpress_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting WordPress installation..."

# --- System update and required packages installation --- #

echo "Updating system and installing required packages..."
sudo apt update && sudo apt upgrade -y && sleep 2
sudo apt install -y nginx mysql-client php-fpm php-mysql php-xml php-mbstring php-curl php-redis unzip || {
  echo "Package installation failed. Please check the connection and package availability."
  exit 1
}

# --- Download and install WordPress --- #

echo "Downloading and installing WordPress..."
cd /tmp || exit
curl -O https://wordpress.org/latest.zip
unzip latest.zip || { echo "Failed to unzip WordPress package."; exit 1; }
sudo mv wordpress /var/www/html/wordpress
rm latest.zip  # Clean up downloaded zip file

# Set permissions for WordPress directory
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 750 /var/www/html/wordpress

# Copy default WordPress config
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php || { echo "Failed to copy WordPress config file."; exit 1; }

# --- Set environment variables for database and Redis --- #

DB_NAME="${DB_NAME:-default_db_name}"
DB_USER="${DB_USER:-default_db_user}"
DB_PASSWORD="${DB_PASSWORD:-default_db_password}"
DB_HOST="${DB_HOST:-default_rds_host_endpoint}"

REDIS_HOST="${REDIS_HOST:-default_redis_host}"
REDIS_PORT="${REDIS_PORT:-6379}"

# Configure wp-config.php for database connection
echo "Configuring wp-config.php for database connection..."
sudo sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/localhost/$DB_HOST/" /var/www/html/wordpress/wp-config.php

# Add Redis configuration to wp-config.php
echo "Adding Redis configuration to wp-config.php..."
sudo tee -a /var/www/html/wordpress/wp-config.php > /dev/null <<EOL
# Redis configuration
define('WP_REDIS_HOST', '$REDIS_HOST');
define('WP_REDIS_PORT', $REDIS_PORT);
define('WP_CACHE', true);
EOL

# Set secure permissions for wp-config.php
sudo chmod 640 /var/www/html/wordpress/wp-config.php

# --- Configure Nginx for WordPress --- #

echo "Configuring Nginx for WordPress..."
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
        fastcgi_pass unix:/run/php/php-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL

# Enable Nginx configuration and restart service
echo "Enabling Nginx configuration and restarting the service..."
sudo ln -sf /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
if sudo nginx -t; then
  sudo systemctl restart nginx
else
  echo "Failed to restart Nginx. Check configuration."
  exit 1
fi

# --- Enable Nginx and PHP-FPM to start on boot --- #

echo "Enabling Nginx and PHP-FPM to start on boot..."
sudo systemctl enable --now nginx
sudo systemctl enable --now php-fpm

# --- Configure UFW Firewall (if enabled) --- #

if sudo ufw status | grep -qw "active"; then
  echo "Configuring UFW firewall for Nginx..."
  sudo ufw allow 'Nginx Full'
fi

# --- Final Check --- #

echo "Checking Nginx status..."
curl -I localhost || echo "Nginx may not be running. Please check the configuration."

echo "WordPress installation and configuration complete."
