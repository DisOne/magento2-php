FROM php:7.0-fpm
MAINTAINER Harry Disseldorp <h.disseldorp@gmail.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cron \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxslt1-dev

RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
    bcmath \
    gd \
    intl \
    mcrypt \
    pdo_mysql \
    soap \
    xsl \
    zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV PHP_MEMORY_LIMIT=756M \
    PHP_TIMEZONE=Europe/Kiev \
    PHP_PORT=9000 \
    PHP_PM=dynamic \
    PHP_PM_MAX_CHILDREN=10 \
    PHP_PM_START_SERVERS=4 \
    PHP_PM_MIN_SPARE_SERVERS=2 \
    PHP_PM_MAX_SPARE_SERVERS=6 \
    APP_MAGE_MODE=default

COPY conf/www.conf /usr/local/etc/php-fpm.d/
COPY conf/php.ini /usr/local/etc/php/
COPY conf/php-fpm.conf /usr/local/etc/
COPY bin/* /usr/local/bin/

WORKDIR /var/www/html

CMD ["/usr/local/bin/start"]
