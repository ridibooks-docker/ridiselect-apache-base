FROM php:7.2.13-apache-stretch

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i -e "s/\/\/archive\.ubuntu/\/\/mirror\.kakao/" /etc/apt/sources.list

RUN pecl install xdebug-2.6.0 \
&& docker-php-ext-install pdo_mysql \
&& docker-php-ext-enable \
    opcache \
    xdebug \
&& docker-php-source delete && rm -rf /tmp/*

RUN mkdir -p /usr/local/etc/php/apache2 \
&& cp -R /usr/local/etc/php/conf.d /usr/local/etc/php/apache2 \
&& echo 'export PHP_INI_SCAN_DIR=/usr/local/etc/php/apache2/conf.d' >> /etc/apache2/envvars

COPY php/cli.ini /usr/local/etc/php/php.ini
COPY php/apache.ini /usr/local/etc/php/apache2/apache.ini

ENV PHP_TIMEZONE="Asia/Seoul" \
    PHP_OPCACHE_ENABLE="0" \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10" \
    PHP_XDEBUG_ENABLE="0" \
    PHP_XDEBUG_REMOTE_HOST="host.docker.internal" \
    APACHE_DOC_ROOT="/app/public"

RUN a2enmod rewrite
COPY ./index.php /app/public/index.php
COPY ./health.php /app/public/health.php

# Change entrypoint
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
