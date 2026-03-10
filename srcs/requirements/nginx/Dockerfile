# NGINX setup:
#   - Forward to wordpress
#   

FROM debian:stable
RUN apt-get update && apt-get install -y tini curl nginx openssl ca-certificates
RUN mkdir -p /etc/nginx/ssl
RUN openssl genpkey -algorithm RSA -out /etc/nginx/ssl/inception.key
RUN openssl req -new -x509 \
            -days 30 \
            -key /etc/nginx/ssl/inception.key\
            -out /etc/nginx/ssl/inception.crt\
            -subj "/C=de/ST=BW/L=Heilbronn/O=42/CN=afelger.42.fr"\
            -addext "subjectAltName=DNS:afelger.42.fr,DNS:afelger.42.de"
RUN mkdir -p /run/nginx
COPY conf /etc/nginx/nginx.conf
HEALTHCHECK --start-period=30s --interval=30s --timeout=5s --retries=3\
    CMD curl -f -s -k https://127.0.0.1/ -o /dev/null || exit 1
EXPOSE 443
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["nginx", "-g", "daemon off;"]