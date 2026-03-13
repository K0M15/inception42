FROM alpine:latest

RUN apk update && apk add --no-cache vsftpd libpam-pwdfile merecat 
EXPOSE 21
COPY conf /etc/vsftpd/vsftpd.conf
CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]
