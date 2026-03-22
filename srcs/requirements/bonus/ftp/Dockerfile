# Use a stable, lightweight base
FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y pure-ftpd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd ftpgroup && \
    useradd -g ftpgroup -d /home/ftpuser -s /bin/sh ftpuser

RUN mkdir -p /home/ftpuser && chown ftpuser:ftpgroup /home/ftpuser

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 21 30000-30009

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Passing flags to entrypoint.sh:
# -d: debug (useful for Docker logs)
# -P: Passive Host (set to localhost for host access)
# -p: Passive Port Range
CMD ["-l", "puredb:/etc/pure-ftpd/pureftpd.pdb", "-E", "-j", "-d", "-P", "localhost", "-p", "30000:30009"]