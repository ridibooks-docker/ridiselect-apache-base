#!/usr/bin/env bash

set -e

# Configure PHP xdebug
if [[ ! -z "${PHP_XDEBUG_ENABLE}" && "${PHP_XDEBUG_ENABLE}" != "0" ]]
then
    PHP_XDEBUG_INI_PATH=/etc/php/7.2/apache2/conf.d/20-xdebug.ini
    echo "zend_extension=xdebug.so" > "${PHP_XDEBUG_INI_PATH}"
    echo "xdebug.remote_enable=1" >> "${PHP_XDEBUG_INI_PATH}"
    echo "xdebug.remote_host=${PHP_XDEBUG_REMOTE_HOST:-host.docker.internal}" >> "${PHP_XDEBUG_INI_PATH}"
    echo "xdebug.remote_port=9000" >> "${PHP_XDEBUG_INI_PATH}"
    echo "xdebug.default_enable=1" >> "${PHP_XDEBUG_INI_PATH}"
    echo "xdebug.coverage_enable=1" >> "${PHP_XDEBUG_INI_PATH}"
    echo "xdebug.profiler_enable_trigger=1" >> "${PHP_XDEBUG_INI_PATH}"
    echo "xdebug.profiler_output_name=xdebug-profile-cachegrind.out-%H-%R" >> "${PHP_XDEBUG_INI_PATH}"
    echo "xdebug.var_display_max_children=128" >> "${PHP_XDEBUG_INI_PATH}"
    echo "xdebug.var_display_max_data=2048" >> "${PHP_XDEBUG_INI_PATH}"
    echo "xdebug.var_display_max_depth=128" >> "${PHP_XDEBUG_INI_PATH}"
    echo "xdebug.max_nesting_level=200" >> "${PHP_XDEBUG_INI_PATH}"

    cp "${PHP_XDEBUG_INI_PATH}" /etc/php/7.2/cli/conf.d/20-xdebug.ini
fi

# Configure Datadog
if [[ ! -z "${DD_ENABLED}" && "${DD_ENABLED}" != "0" ]]
then
    export DD_TRACE_ENABLED=1
    export DD_SERVICE_NAME=${DD_SERVICE_NAME:-ridiselect}
else 
    export DD_TRACE_ENABLED=0
fi

# Configure Blackfire
if [[ ! -z "${PHP_BLACKFIRE_ENABLE}" && "${PHP_BLACKFIRE_ENABLE}" != "0" ]]
then
    PHP_BLACKFIRE_INI_PATH=/etc/php/7.2/apache2/conf.d/20-blackfire.ini
    echo "extension=blackfire.so" > "${PHP_BLACKFIRE_INI_PATH}"
    echo "blackfire.log_file=/var/log/blackfile/blackfire.log" >> "${PHP_BLACKFIRE_INI_PATH}"
    echo "blackfire.log_level=${PHP_BLACKFIRE_LOG_LEVEL:-1}" >> "${PHP_BLACKFIRE_INI_PATH}"
    echo "blackfire.agent_socket=tcp://${PHP_BLACKFIRE_AGENT_HOST:-blackfire}:${PHP_BLACKFIRE_AGENT_PORT:-8707}" >> "${PHP_BLACKFIRE_INI_PATH}"
    echo "blackfire.agent_timeout=${PHP_BLACKFIRE_AGENT_TIMEOUT:-0.25}" >> "${PHP_BLACKFIRE_INI_PATH}"

    cp "${PHP_BLACKFIRE_INI_PATH}" /etc/php/7.2/cli/conf.d/20-blackfire.ini
fi

# Configure Apache document root
APACHE_DOC_ROOT="${APACHE_DOC_ROOT:-/app/public}"

mkdir -p "${APACHE_DOC_ROOT}"
chown www-data:www-data "${APACHE_DOC_ROOT}"
sed -i "s|DocumentRoot /var/www/html\$|DocumentRoot ${APACHE_DOC_ROOT}|" /etc/apache2/sites-available/000-default.conf

APACHE_DOC_ROOT_CONFI_PATH=/etc/apache2/conf-available/document-root-directory.conf
echo "<Directory ${APACHE_DOC_ROOT}>" > "${APACHE_DOC_ROOT_CONFI_PATH}"
echo "  AllowOverride All" >> "${APACHE_DOC_ROOT_CONFI_PATH}"
echo "  Require all granted" >> "${APACHE_DOC_ROOT_CONFI_PATH}"
echo "</Directory>" >> "${APACHE_DOC_ROOT_CONFI_PATH}"

a2enconf "document-root-directory.conf"

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

exec "${@}"
