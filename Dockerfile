FROM ubuntu:bionic

RUN TZ="Asia/Seoul" \
&& ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
&& sed -i -e "s/\/\/archive\.ubuntu/\/\/mirror\.kakao/" /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y \
    apache2 \
    ca-certificates \
    php7.2 \
    php7.2-cli \
    php7.2-curl \
    php7.2-mbstring \
    php7.2-mysql \
    php-xdebug \
&& apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y \
&& rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN a2disconf other-vhosts-access-log \
&& ln -sfT /dev/stderr /var/log/apache2/error.log \
&& ln -sfT /dev/stdout /var/log/apache2/access.log \
&& ln -sfT /dev/stdout /var/log/apache2/other_vhosts_access.log \
&& chown -R --no-dereference www-data:www-data /var/log/apache2

COPY php/apache.ini /etc/php/7.2/apache2/php.ini
COPY php/cli.ini /etc/php/7.2/cli/php.ini

ENV APACHE_DOC_ROOT /app/public

COPY ./index.php /app/public/index.php
COPY ./health.php /app/public/health.php

# Change entrypoint
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2ctl", "-D", "FOREGROUND"]
