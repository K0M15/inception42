#!/bin/bash
set -e

# Load Docker secrets into environment variables
if [ -d "/run/secrets" ]; then
    for secret in /run/secrets/*; do
        if [ -f "$secret" ]; then
            var_name=$(basename "$secret" | tr '[:lower:]' '[:upper:]')
            export "$var_name"=$(cat "$secret")
        fi
    done
fi

# Default DB name if not provided
export WP_DB_NAME=${WP_DB_NAME:-wordpress}

# Wait for MariaDB to be available
echo "Waiting for MariaDB..."
DB_HOST_ONLY=$(echo "${WORDPRESS_DB_HOST:-mariadb}" | cut -d: -f1)
while ! mariadb -h"$DB_HOST_ONLY" -u"$WP_DB_USER" -p"$WP_DB_PASS" -e "SELECT 1" &> /dev/null && \
      ! mysql -h"$DB_HOST_ONLY" -u"$WP_DB_USER" -p"$WP_DB_PASS" -e "SELECT 1" &> /dev/null; do
    echo "MariaDB is unavailable - sleeping"
    sleep 2
done
echo "MariaDB is ready!"

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$WP_DB_NAME" \
        --dbuser="$WP_DB_USER" \
        --dbpass="$WP_DB_PASS" \
        --dbhost="${WORDPRESS_DB_HOST:-mariadb}" \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url="afelger.42.fr" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER:-admin}" \
        --admin_password="${WP_ADMIN_PASS:-adminpass}" \
        --admin_email="${WP_ADMIN_MAIL:-admin@example.com}" \
        --allow-root

    echo "Creating WordPress user..."
    wp user create "${WP_USER_NAME:-user}" "${WP_USER_MAIL:-user@example.com}" \
        --user_pass="${WP_USER_PASS:-userpass}" \
        --role="${WP_USER_ROLE:-author}" \
        --allow-root
    
    # Ensure proper permissions
    chown -R www-data:www-data /var/www/html
fi

echo "Starting PHP-FPM..."
# Find the installed php-fpm binary. In Debian it's usually /usr/sbin/php-fpm8.2 etc.
PHP_FPM=$(find /usr/sbin -name "php-fpm*" -type f | head -n 1)
exec "$PHP_FPM" -F
