FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y redis-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# # Add redis to its own group
# RUN groupadd -r redis 
# RUN useradd -r -g redis redis

# Redis default data directory
RUN mkdir -p /var/lib/redis && chown -R redis:redis /var/lib/redis

COPY conf/redis.conf /etc/redis/redis.conf
RUN chown redis:redis /etc/redis/redis.conf

EXPOSE 6379

USER redis

CMD ["redis-server", "/etc/redis/redis.conf"]
