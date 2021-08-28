FROM alpine:latest
MAINTAINER seantur

RUN apk add borgbackup openssh supervisor --no-cache \
    && adduser -D borg \
    && echo -e "[supervisord]\nnodaemon=true\nuser=root\n[program:sshd]\ncommand=/usr/sbin/sshd -D"\
        > /etc/supervisord.conf \
    && ssh-keygen -A \
    && sed -i \
        -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
        -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
        /etc/ssh/sshd_config
EXPOSE 22
RUN passwd -u borg
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
