#!/usr/bin/env bash

set -e

# Configure PHP xdebug
if [[ ! -z "${PHP_XDEBUG_ENABLE}" ]]
then
    PHP_XDEBUG_INI_PATH=/etc/php/7.2/apache2/conf.d/20-xdebug.ini
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
