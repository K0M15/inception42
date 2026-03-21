FROM debian:stable

RUN apt update && apt install php php-mysqli curl -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
RUN curl -L -O https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php \
    && mv adminer-5.4.2.php index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080"]

