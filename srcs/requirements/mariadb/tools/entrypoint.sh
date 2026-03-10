#!/bin/bash
set -e

# Wait for filesystem to be ready (optional but recommended)
sleep 2

# Check if the database has already been initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB in background to set up database
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"

    # Wait for the background mariadb server to start up
    echo "Wait for MariaDB to start up..."
    until mariadb-admin ping --silent; do
        sleep 1
    done

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

# Run the final MariaDB command
echo "Starting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
