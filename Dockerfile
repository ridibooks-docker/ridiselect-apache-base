FROM ubuntu:bionic

RUN TIMEZONE="${TIMEZONE:-Asia/Seoul}" \
&& ln -snf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime && echo "${TIMEZONE}" > /etc/timezone \
&& sed -i -e "s/\/\/archive\.ubuntu/\/\/mirror\.kakao/" /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y \
    apache2 \
    ca-certificates \
    curl \
    php7.2 \
    php7.2-bcmath \
    php7.2-cli \
    php7.2-curl \
    php7.2-mbstring \
    php7.2-mysql \
    php-xdebug \
&& rm /etc/php/7.2/apache2/conf.d/20-xdebug.ini \
&& rm /etc/php/7.2/cli/conf.d/20-xdebug.ini \
&& apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y \
&& rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

ENV DD_TRACER_VERSION 0.39.2
RUN curl -sL -o /tmp/dd-php-tracer \
    "https://github.com/DataDog/dd-trace-php/releases/latest/download/datadog-php-tracer_${DD_TRACER_VERSION}_amd64.deb" \
&& dpkg -i /tmp/dd-php-tracer \
&& rm -rf /tmp/dd-php-tracer

RUN a2disconf other-vhosts-access-log \
&& ln -sfT /dev/stderr /var/log/apache2/error.log \
&& ln -sfT /dev/stdout /var/log/apache2/access.log \
&& ln -sfT /dev/stdout /var/log/apache2/other_vhosts_access.log \
&& chown -R --no-dereference www-data:www-data /var/log/apache2

COPY config/apache2/apache2.conf /etc/apache2/apache2.conf
COPY config/apache2/security.conf /etc/apache2/conf-available/security.conf
COPY config/php/apache.ini /etc/php/7.2/apache2/php.ini
COPY config/php/cli.ini /etc/php/7.2/cli/php.ini

COPY ./index.php /app/public/index.php
COPY ./health.php /app/public/health.php

# Change entrypoint
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
