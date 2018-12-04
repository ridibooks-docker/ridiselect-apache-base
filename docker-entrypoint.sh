#!/usr/bin/env bash

set -e

# Configure Apache Document Root
mkdir -p ${APACHE_DOC_ROOT}
chown www-data:www-data ${APACHE_DOC_ROOT}
sed -i "s|DocumentRoot /var/www/html\$|DocumentRoot ${APACHE_DOC_ROOT}|" /etc/apache2/sites-available/000-default.conf
echo "<Directory ${APACHE_DOC_ROOT}>" > /etc/apache2/conf-available/document-root-directory.conf
echo "  AllowOverride All" >> /etc/apache2/conf-available/document-root-directory.conf
echo "  Require all granted" >> /etc/apache2/conf-available/document-root-directory.conf
echo "</Directory>" >> /etc/apache2/conf-available/document-root-directory.conf
a2enconf "document-root-directory.conf"

exec "$@"
