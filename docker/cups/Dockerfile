FROM alpine:latest

RUN apk update && \
    apk add --no-cache cups cups-libs cups-client cups-filters && \ 
    apk add --no-cache samba samba-client && \
    apk add --no-cache tzdata

ARG TZ='Europe/Warsaw'
ENV TZ ${TZ}
RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "Europe//Warsaw" >  /etc/timezone \
    && rm -rf /var/cache/apk/* 

WORKDIR /root
COPY start.sh /root
RUN chmod +x start.sh
RUN ntpd -p ntp.bskielce.com.pl

CMD ["sh","-c","/root/start.sh"]
