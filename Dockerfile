ARG PHP_SERVER_VER=7.2-fpm-alpine

FROM php:$PHP_SERVER_VER

ARG PHP_REDIS_VER=4.3.0
ARG PHP_XDEBUG_VER=2.7.0

WORKDIR /var/www/html

RUN apk add --no-cache --virtual .build-deps \
      build-base \
      autoconf \
      freetype-dev \
      libpng-dev \
      libjpeg-turbo-dev \
      libzip-dev \
      libxslt-dev \
      icu-dev \
      zlib-dev && \
    apk add --no-cache --virtual .runtime-deps \
      bash \
      freetype \
      libpng \
      libjpeg-turbo \
      icu-libs \
      libxslt \
      libzip && \
    docker-php-ext-configure gd \
      --with-freetype-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include \
      --with-png-dir=/usr/include && \
    docker-php-ext-configure zip \
      --with-libzip && \
    docker-php-ext-install \
      zip \
      gd \
      xsl \
      pdo_mysql \
      opcache \
      bcmath \
      soap \
      intl && \
    pecl install redis-$PHP_REDIS_VER && \
    pecl install xdebug-$PHP_XDEBUG_VER && \
    docker-php-ext-enable redis && \
    apk del --no-network .build-deps

COPY docker/mage2/etc /usr/local/etc/
COPY docker/mage2/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN chmod +x /usr/local/bin/docker-entrypoint

ENV PHP_MEMORY_LIMIT 2G
ENV PHP_ENABLE_XDEBUG false
ENV UPLOAD_MAX_FILESIZE 64M
ENV MAGENTO_ROOT /var/www/html
ENV MAGENTO_RUN_MODE developer
ENV DEBUG false

ENTRYPOINT ["docker-entrypoint"]

EXPOSE 9000

CMD ["php-fpm"]
