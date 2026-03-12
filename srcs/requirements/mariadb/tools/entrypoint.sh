#!/bin/bash
set -e

# Wait for filesystem to be ready (optional but recommended)
sleep 2

# Load Docker secrets into environment variables
if [ -d "/run/secrets" ]; then
    for secret in /run/secrets/*; do
        if [ -f "$secret" ]; then
            var_name=$(basename "$secret" | tr '[:lower:]' '[:upper:]')
            export "$var_name"=$(cat "$secret")
        fi
    done
fi

# Check if the database has already been initialized by looking for our specific database
if [ ! -d "/var/lib/mysql/${WP_DB_NAME:-wordpress}" ]; then
    echo "Database not found. Initializing MariaDB data directory..."
    
    # Ensure directory exists and has correct permissions
    mkdir -p /var/lib/mysql
    chown -R mysql:mysql /var/lib/mysql
    
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB in background to set up database
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"

    # Wait for the background mariadb server to start up
    echo "Wait for MariaDB to start up..."
    until mariadb-admin ping --silent; do
        sleep 1
    done

    echo "WP DB NAME: " $WP_DB_NAME "WP DB USER" $WP_DB_USER

    # Create initialization SQL script
    cat << EOF > /tmp/init.sql
CREATE DATABASE IF NOT EXISTS \`${WP_DB_NAME:-wordpress}\`;
CREATE USER IF NOT EXISTS \`${WP_DB_USER}\`@'%' IDENTIFIED BY '${WP_DB_PASS}';
GRANT ALL PRIVILEGES ON \`${WP_DB_NAME:-wordpress}\`.* TO \`${WP_DB_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ADMIN_DB_PASS}';
FLUSH PRIVILEGES;
EOF

    # Execute it
    echo "Configuring database users and permissions..."
    mariadb -u root < /tmp/init.sql
    rm /tmp/init.sql

    # Stop background MariaDB server
    kill -s TERM "$pid"
    wait "$pid"
    echo "MariaDB configuration finished."
fi
echo "WP DB NAME: " $WP_DB_NAME "WP DB USER" $WP_DB_USER
# Run the final MariaDB command
echo "Starting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
