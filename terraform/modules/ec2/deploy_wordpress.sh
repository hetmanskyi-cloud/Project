#!/bin/bash

# Update and upgrade system packages
sudo apt update && sudo apt upgrade -y

# Install required packages: Nginx, MySQL client, PHP, unzip, and other necessary extensions
sudo apt install -y nginx mysql-client php-fpm php-mysql php-xml php-mbstring php-curl php-redis unzip || {
  echo "Package installation failed. Please check your package manager and network connection."
  exit 1
}

# Download and install WordPress
cd /tmp || exit
curl -O https://wordpress.org/latest.zip
if ! command -v unzip &> /dev/null; then
  echo "Unzip is not installed. Attempting to install unzip."
  sudo apt install -y unzip || { echo "Failed to install unzip. Exiting."; exit 1; }
fi
unzip latest.zip
sudo mv wordpress /var/www/html/wordpress

# Set proper permissions for the WordPress directory
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 750 /var/www/html/wordpress

# Create WordPress configuration file
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# Set WordPress environment variables for database and Redis connection
DB_NAME="${DB_NAME:-default_db_name}"
DB_USER="${DB_USER:-default_db_user}"
DB_PASSWORD="${DB_PASSWORD:-default_db_password}"
DB_HOST="${DB_HOST:-default_rds_host_endpoint}"

REDIS_HOST="${REDIS_HOST:-default_redis_host}"
REDIS_PORT="${REDIS_PORT:-6379}"

# Update wp-config.php with the MySQL and Redis configurations
sudo sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/localhost/$DB_HOST/" /var/www/html/wordpress/wp-config.php

# Add Redis configuration to wp-config.php
sudo tee -a /var/www/html/wordpress/wp-config.php > /dev/null <<EOL

# Redis configuration
define('WP_REDIS_HOST', '$REDIS_HOST');
define('WP_REDIS_PORT', '$REDIS_PORT');
EOL

# Configure Nginx for WordPress
sudo tee /etc/nginx/sites-available/wordpress <<EOL
server {
    listen 80;
    server_name _;

    root /var/www/html/wordpress;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    }
}
EOL

# Enable the WordPress site and disable the default Nginx site
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Restart Nginx to apply the changes
sudo systemctl restart nginx

# Install Redis plugin for WordPress
cd /var/www/html/wordpress/wp-content/plugins || exit
curl -O https://downloads.wordpress.org/plugin/redis-cache.latest-stable.zip
unzip redis-cache.latest-stable.zip
rm redis-cache.latest-stable.zip

# Set the proper permissions for the plugin directory
sudo chown -R www-data:www-data /var/www/html/wordpress/wp-content/plugins

# Restart PHP and Nginx to apply Redis cache
sudo systemctl restart php8.2-fpm
sudo systemctl restart nginx

# Output message
echo "WordPress installation and configuration completed!"
