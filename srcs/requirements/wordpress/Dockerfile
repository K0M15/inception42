
FROM debian:stable
RUN apt-get update && apt-get install -y \
    tini \
    php-fpm \
    php-cli \
    php-common \
    php-mysql \
    php-xml \
    php-mbstring \
    php-gd \
    php-curl \
    php-zip \
    php-intl \
    php-json \
    php-opcache \
    php-exif \
    php-bcmath \
    php-imagick \
    curl \
    ca-certificates \
    tar \
    gzip \
    mariadb-client

RUN mkdir -p /var/www/html
RUN mkdir -p /run/php

RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf \
 && sed -i 's|^;listen.owner = .*|listen.owner = www-data|' /etc/php/*/fpm/pool.d/www.conf \
 && sed -i 's|^;listen.group = .*|listen.group = www-data|' /etc/php/*/fpm/pool.d/www.conf \
 && sed -i 's|^;listen.mode = .*|listen.mode = 0660|' /etc/php/*/fpm/pool.d/www.conf

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy setup script
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000 
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/setup.sh"]