# Database setup:
#   - MariaDB
#   

FROM debian:stable
RUN apt-get update && apt-get install -y tini
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["your-app"]