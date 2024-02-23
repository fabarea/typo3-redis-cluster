#!/bin/bash

# FYI: this script is executed as root

# copy some config files
cp /tmp/default.conf /etc/nginx/conf.d

# Replace some default values
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php.ini
sed -i 's/;max_input_vars = 1000/max_input_vars = 3000/g' /etc/php.ini
sed -i 's/display_errors = Off/display_errors = On/g' /etc/php.ini

# Restart services
systemctl restart php-fpm nginx


# copy some config files
if [ ! -f /var/www/html/typo3/public/typo3conf/AdditionalConfiguration.php ]; then
  cp /tmp/AdditionalConfiguration.php /var/www/html/typo3/public/typo3conf/AdditionalConfiguration.php
  chown apache:apache /var/www/html/typo3/public/typo3conf/AdditionalConfiguration.php

  cp /tmp/.env /var/www/html/typo3/.env
  chown apache:apache /var/www/html/typo3/.env
fi

# same but with ip command
ip=$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

echo "Install TYPO3 at http://${ip}"
echo "At the end of the installation, you can install the introduction package"
echo "sudo -u apache /var/www/html/typo3/vendor/bin/typo3cms extension:setup"
echo ""
echo "log can be found at"
echo "tail -f /var/log/php-fpm/www-error.log"
