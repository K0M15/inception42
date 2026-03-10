# Database setup:
#   - MariaDB
#   

FROM debian:stable
RUN groupadd -r mysql && useradd -r -g mysql mysql --home-dir /var/lib/mysql
# Modify default bind-address so mariadb isn't just listening to localhost
RUN apt-get update \
    && apt-get install -y tini mariadb-server \
    && sed -i "s/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/g" /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

ENTRYPOINT ["/usr/bin/tini", "--"]

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]