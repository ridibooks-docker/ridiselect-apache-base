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

RUN curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s \
    "https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;")" \
&& mkdir -p /tmp/blackfire \
&& tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
&& mv /tmp/blackfire/blackfire-*.so "$(php -r "echo ini_get('extension_dir');")/blackfire.so" \
&& rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz \
&& mkdir -p /var/log/blackfire \
&& ln -sfT /dev/stdout /var/log/blackfire/blackfire.log \
&& chown -R --no-dereference www-data:www-data /var/log/blackfire

RUN a2disconf other-vhosts-access-log \
&& ln -sfT /dev/stderr /var/log/apache2/error.log \
&& ln -sfT /dev/stdout /var/log/apache2/access.log \
&& ln -sfT /dev/stdout /var/log/apache2/other_vhosts_access.log \
&& chown -R --no-dereference www-data:www-data /var/log/apache2

COPY php/apache.ini /etc/php/7.2/apache2/php.ini
COPY php/cli.ini /etc/php/7.2/cli/php.ini

COPY ./index.php /app/public/index.php
COPY ./health.php /app/public/health.php

# Change entrypoint
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
