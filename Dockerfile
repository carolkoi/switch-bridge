FROM alpine:3
RUN apk update && apk add openssl php7-openssl php7-tokenizer php-phar  php7-apache2 php7-pdo_pgsql php7-ctype php7-mbstring php7-pgsql php7-session php7-pdo php7-cli php7-curl php7-json php7-cli php7-mcrypt curl tzdata
RUN rm /var/www/localhost/htdocs/index.html
RUN curl -s https://getcomposer.org/installer | php
COPY composer.phar /usr/bin/composer
RUN alias composer='php composer.phar'

COPY . /var/www/localhost/htdocs/
COPY httpd.conf /etc/httpd/conf/httpd.conf
RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/httpd/conf/httpd.conf

RUN chmod -R 777 /var/www/localhost/htdocs/storage
RUN cp /usr/share/zoneinfo/Africa/Nairobi /etc/localtime
RUN apk del tzdata
CMD php artisan config:cache
CMD php artisan cache:clear
CMD php artisan route:clear

EXPOSE 80
ENTRYPOINT ["httpd"]
CMD ["-D", "FOREGROUND"]
