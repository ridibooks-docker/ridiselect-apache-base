#!/usr/bin/env bash

set -e

# Configure PHP opcache
if [[ ! -z "${PHP_OPCODE_ENABLE}" ]]
then
    # Note: If you want to use Xdebug and OPCache together, you must load Xdebug after OPCache.
    PHP_OPCODE_INI_PATH=/usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
    echo "opcache.enable=1" >> ${PHP_OPCODE_INI_PATH}
    echo "opcache.enable_cli=1" >> ${PHP_OPCODE_INI_PATH}
    echo "opcache.validate_timestamps=${PHP_OPCACHE_VALIDATE_TIMESTAMPS}" >> ${PHP_OPCODE_INI_PATH}
    echo "opcache.memory_consumption=${PHP_OPCACHE_MEMORY_CONSUMPTION}" >> ${PHP_OPCODE_INI_PATH}
    echo "opcache.max_accelerated_files=${PHP_OPCACHE_MAX_ACCELERATED_FILES}" >> ${PHP_OPCODE_INI_PATH}
    echo "opcache.max_wasted_percentage=${PHP_OPCACHE_MAX_WASTED_PERCENTAGE}" >> ${PHP_OPCODE_INI_PATH}
    echo "opcache.interned_strings_buffer=16" >> ${PHP_OPCODE_INI_PATH}
fi

# Configure PHP xdebug
if [[ ! -z "${PHP_XDEBUG_ENABLE}" ]]
then
    PHP_XDEBUG_INI_PATH=/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
    echo "xdebug.remote_enable=1" >> ${PHP_XDEBUG_INI_PATH}
    echo "xdebug.remote_host=${PHP_XDEBUG_REMOTE_HOST}" >> ${PHP_XDEBUG_INI_PATH}
    echo "xdebug.remote_port=9000" >> ${PHP_XDEBUG_INI_PATH}
    echo "xdebug.default_enable=1" >> ${PHP_XDEBUG_INI_PATH}
    echo "xdebug.coverage_enable=1" >> ${PHP_XDEBUG_INI_PATH}
    echo "xdebug.profiler_enable_trigger=1" >> ${PHP_XDEBUG_INI_PATH}
    echo "xdebug.profiler_output_name=xdebug-profile-cachegrind.out-%H-%R" >> ${PHP_XDEBUG_INI_PATH}
    echo "xdebug.var_display_max_children=128" >> ${PHP_XDEBUG_INI_PATH}
    echo "xdebug.var_display_max_data=2048" >> ${PHP_XDEBUG_INI_PATH}
    echo "xdebug.var_display_max_depth=128" >> ${PHP_XDEBUG_INI_PATH}
    echo "xdebug.max_nesting_level=200" >> ${PHP_XDEBUG_INI_PATH}
fi

# Configure Apache document root
mkdir -p ${APACHE_DOC_ROOT}
chown www-data:www-data ${APACHE_DOC_ROOT}
sed -i "s|DocumentRoot /var/www/html\$|DocumentRoot ${APACHE_DOC_ROOT}|" /etc/apache2/sites-available/000-default.conf

APACHE_DOC_ROOT_CONFI_PATH=/etc/apache2/conf-available/document-root-directory.conf
echo "<Directory ${APACHE_DOC_ROOT}>" > ${APACHE_DOC_ROOT_CONFI_PATH}
echo "  AllowOverride All" >> ${APACHE_DOC_ROOT_CONFI_PATH}
echo "  Require all granted" >> ${APACHE_DOC_ROOT_CONFI_PATH}
echo "</Directory>" >> ${APACHE_DOC_ROOT_CONFI_PATH}
a2enconf "document-root-directory.conf"

exec "$@"
