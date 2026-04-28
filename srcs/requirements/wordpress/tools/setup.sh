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
echo "HOST: " $DB_HOST_ONLY "USER: " $WP_DB_USER "PASS: " $WP_DB_PASS
while ! mariadb -h"$DB_HOST_ONLY" -u"$WP_DB_USER" -p"$WP_DB_PASS" -e "SELECT 1" &> /dev/null; do \
    echo "MariaDB is unavailable - sleeping"
    sleep 2
done
echo "MariaDB is ready!"

cd /var/www/html

if [ ! -f wp-load.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
fi

if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$WP_DB_NAME" \
        --dbuser="$WP_DB_USER" \
        --dbpass="$WP_DB_PASS" \
        --dbhost="${WORDPRESS_DB_HOST:-mariadb}" \
        --allow-root
fi

if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url="${DOMAIN_NAME:-afelger.42.fr}" \
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
    
fi

if ! wp plugin is-installed redis-cache --allow-root; then
    echo "Configuring Redis..."
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp config set WP_CACHE true --raw --allow-root
    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root
fi

chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
PHP_FPM=$(find /usr/sbin -name "php-fpm*" -type f | head -n 1)
exec "$PHP_FPM" -F
