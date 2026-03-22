FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y vsftpd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ftpuser

RUN mkdir -p /var/run/vsftpd/empty && \
    mkdir -p /home/ftpuser && \
    chown ftpuser:ftpuser /home/ftpuser

COPY tools/vsftpd.conf /etc/vsftpd.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 21 30000-30009

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["vsftpd", "/etc/vsftpd.conf"]