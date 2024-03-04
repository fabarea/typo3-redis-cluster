#!/bin/bash

# FYI: this script is executed as root

# #####################################
# nginx
# #####################################
cp /tmp/default.conf /etc/nginx/conf.d
systemctl restart nginx

# #####################################
# php
# #####################################
# typo3 specific
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php.ini
sed -i 's/;max_input_vars = 1000/max_input_vars = 3000/g' /etc/php.ini

# dev context
sed -i 's/display_errors = Off/display_errors = On/g' /etc/php.ini

# enable session redis storage
sed -i 's/session.save_handler = files/session.save_handler = redis/g' /etc/php.ini
sed -i 's#;session.save_path = "/tmp"#session.save_path = "tcp://master1:6379"#g' /etc/php.ini

systemctl restart php-fpm

# #####################################
# typo3
# #####################################
if [ ! -f /var/www/html/typo3/public/typo3conf/AdditionalConfiguration.php ]; then
  cp /tmp/AdditionalConfiguration.php /var/www/html/typo3/public/typo3conf/AdditionalConfiguration.php
  chown apache:apache /var/www/html/typo3/public/typo3conf/AdditionalConfiguration.php

  cp /tmp/.env /var/www/html/typo3/.env
  chown apache:apache /var/www/html/typo3/.env
fi

# #####################################
# welcome message
# #####################################
ip=$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

echo "Install TYPO3 at http://${ip}"
echo "At the end of the installation, you can install the introduction package"
echo "sudo -u apache /var/www/html/typo3/vendor/bin/typo3cms extension:setup"
echo ""
echo "log can be found at"
echo "tail -f /var/log/php-fpm/www-error.log"