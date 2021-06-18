FROM wordpress

WORKDIR /root

RUN mkdir -p /etc/apache2/ssl \
    && openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj \
    "/C=PL/ST=SW/L=KIELCE/O=BSKielce/CN=bs-docker2.bslocal" \
    -keyout /etc/apache2/ssl/ssl.key -out /etc/apache2/ssl/ssl.crt 

RUN mkdir -p /var/run/apache2/ \
    && a2enmod rewrite \
    && a2enmod ssl

RUN echo "<VirtualHost *:443>\n" >> /etc/apache2/sites-enabled/000-default.conf \
    && echo "  SSLEngine on\n  SSLCertificateFile /etc/apache2/ssl/ssl.crt\n"  >> /etc/apache2/sites-enabled/000-default.conf \
    && echo "  SSLCertificateKeyFile /etc/apache2/ssl/ssl.key\n"  >> /etc/apache2/sites-enabled/000-default.conf \
    && echo "  ServerAdmin webmaster@localhost\n  DocumentRoot /var/www/html\n"  >> /etc/apache2/sites-enabled/000-default.conf \
    && echo "</VirtualHost>"  >> /etc/apache2/sites-enabled/000-default.conf


CMD ["apachectl", "-D", "FOREGROUND"]
