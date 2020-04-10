FROM alpine:3
RUN apk --update add wget \
  curl \
  git \
  grep \
  build-base \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  imagemagick-dev \
  pcre-dev \
  libtool \
  make \
  autoconf \
  g++ \
  cyrus-sasl-dev \
  libgsasl-dev \
  supervisor
RUN apk update && apk add openssl php7-openssl php7-tokenizer php-phar  php7-apache2 php7-pdo_pgsql php7-ctype php7-mbstring php7-pgsql php7-session php7-pdo php7-cli php7-curl php7-json php7-cli php7-mcrypt curl tzdata

RUN rm /var/cache/apk/* && \
    mkdir -p /var/www

COPY supervisord-app.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
