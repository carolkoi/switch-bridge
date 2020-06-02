FROM php:7.2-apache

RUN apt-get update

# 1. development packages
RUN apt-get install -y \
    git \
    zip \
    curl \
    sudo \
    unzip \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    g++

# 2. apache configs + document root
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 3. mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin-
RUN a2enmod rewrite headers

# 4. start with base php config, then add extensions
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# 5. Install Postgres PDO
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    &&  docker-php-ext-install \
    bz2 \
    pdo \
    intl \
    pgsql\
    iconv \
    bcmath \
    opcache \
    calendar \
    mbstring \
    pdo_pgsql \
    zip

# 6. composer
#COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 8. we need a user with the same UID/GID with host user
# so when we execute CLI commands, all the host file's ownership remains intact
# otherwise command from inside container will create root-owned files and directories
ARG uid
RUN useradd -G www-data,root -u $uid -d /home/devuser devuser
RUN mkdir -p /home/devuser/.composer && \
    chown -R devuser:devuser /home/devuser

##9. Set this environment variable to true to set timezone on container start.
#    ENV SET_CONTAINER_TIMEZONE false
##10. Default container timezone as found under the directory /usr/share/zoneinfo/.
#    ENV CONTAINER_TIMEZONE EAT
RUN apt-get install tzdata
ENV TZ=Africa/Nairobi
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "Africa/Nairobi"\n' > /usr/local/etc/php/conf.d/tzone.ini

RUN apt update -qq \
# wkhtmltopdf
    && apt install -y wget xz-utils libxrender1 libssl1.0-dev fontconfig libjpeg62-turbo libxext6  xfonts-base xfonts-75dpi \
    && wget --quiet https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && tar vxf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && cp wkhtmltox/bin/wk* /usr/bin/ \
# cleanup
    && rm wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && rm -rf wkhtmltox \
    && apt-get remove -y wget xz-utils \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && truncate -s 0 /var/log/*log



