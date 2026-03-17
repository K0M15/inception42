FROM debian:stable

RUN apt update && apt install vsftpd tini  -y
EXPOSE 21
# COPY conf /etc/vsftpd/vsftpd.conf
# CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["vsftpd"]
