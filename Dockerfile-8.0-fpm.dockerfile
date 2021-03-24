FROM php:8.0-fpm

### PHP Extension ###
# opcache
RUN docker-php-ext-install opcache
# pdo_mysql
RUN docker-php-ext-install pdo_mysql
# mysqli(向下相容)
RUN docker-php-ext-install mysqli
# exif
RUN docker-php-ext-install exif

# apt
RUN apt-get update \
    # gd
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    # zip
    && apt-get install -y libzip-dev zip \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && apt-get clean

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# redis xdebug swoole
RUN pecl install redis-5.3.2 \
    && pecl install xdebug-3.0.1 \
    && pecl install swoole-4.5.10 \
    && docker-php-ext-enable redis xdebug swoole
