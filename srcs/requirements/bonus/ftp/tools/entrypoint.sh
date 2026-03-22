#!/bin/bash

SECRET_FILE="/run/secrets/ftp_user_pass"
FTP_HOME="/home/ftpuser"

echo "Starting vsftpd entrypoint..."

if [ ! -f "$SECRET_FILE" ]; then
    echo "ERROR: Secret file $SECRET_FILE not found!"
    exit 1
fi

FTP_USER_PASS=$(cat "$SECRET_FILE")
echo "Loaded password from secret."

echo "ftpuser:$FTP_USER_PASS" | chpasswd
echo "Password for ftpuser updated."

mkdir -p "$FTP_HOME"
chown ftpuser:ftpuser "$FTP_HOME"
if [ -n "$NGINX_HOST" ]; then
    echo "Setting pasv_address to $NGINX_HOST..."
    sed -i "s|pasv_address=.*|pasv_address=$NGINX_HOST|" /etc/vsftpd.conf
fi

echo "Starting vsftpd..."
exec "$@"
