#!/bin/bash

# Configuration
FTP_USER_NAME="ftpuser"
SECRET_FILE="/run/secrets/ftp_user_pass"
FTP_HOME="/home/ftpuser"

echo "Starting FTP entrypoint..."

FTP_USER_PASS=$(cat "$SECRET_FILE")

# Ensure home directory exists
mkdir -p "$FTP_HOME"
chown ftpuser:ftpgroup "$FTP_HOME"

# Initialize database
if [ ! -f /etc/pure-ftpd/pureftpd.pdb ]; then
    echo "Creating virtual user..."
    (echo "$FTP_USER_PASS"; echo "$FTP_USER_PASS") | pure-pw useradd "$FTP_USER_NAME" -u ftpuser -d "$FTP_HOME"
    pure-pw mkdb
    echo "Database initialized."
fi

echo "Starting pure-ftpd..."
# -S: Syslog
# -d: Debug
# -P: Passive Host
# -p: Passive Port Range
exec /usr/sbin/pure-ftpd -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P localhost -p 30000:30009
