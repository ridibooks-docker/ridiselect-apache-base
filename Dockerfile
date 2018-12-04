FROM ubuntu:xenial

# 카카오 미러 서버로 저장소 변경
RUN sed -i -e "s/\/\/archive\.ubuntu/\/\/mirror\.kakao/" /etc/apt/sources.list

RUN apt-get update --fix-missing && apt-get install -y \
    software-properties-common \
    curl \
&& LC_ALL=C.UTF-8 apt-add-repository -y ppa:ondrej/php

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y \
    # envsubst 사용을 위해 필요
    gettext-base \
    apache2 \
    build-essential \
    libgmp-dev \
    php7.1 \
    php7.1-cli \
    php7.1-curl \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-apcu \
    php7.1-zip \
    php7.1-bcmath \
    libapache2-mod-php7.1 \
    php-bcmath \
    php-xdebug \
    # install pecl
    php7.1-dev \
    php7.1-xml \
    php-pear

COPY php/apache.ini /etc/php/7.1/apache2/php.ini
COPY php/cli.ini /etc/php/7.1/cli/php.ini

# enable apache modules
RUN a2enmod rewrite expires headers proxy proxy_http

ENV APACHE_DOC_ROOT /var/www/html

COPY ./index.php /var/www/html/index.php
COPY ./health.php /var/www/html/health.php

# Change entrypoint
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2ctl", "-D", "FOREGROUND"]
