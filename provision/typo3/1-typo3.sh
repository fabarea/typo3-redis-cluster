#!/bin/bash

FLAG_FILE="/etc/vagrant_provisioned"

# Only once
if [ ! -f "$FLAG_FILE" ]; then

  # Set MySQL root password
  mysqladmin -u root password "root"

  # Enable apache shell for development purpose
  chsh -s /bin/bash apache

  # Install TYPO3 dependencies
  echo "Installing TYPO3 specific dependencies"
  yum install -y ImageMagick GraphicsMagick ghostscript

  # Enabling various folder for apache user such as .composer, .vim, .ssh, .vscode-server, .cache, .config, .local, .java
  chown apache:apache /usr/share/httpd

  # SELinux serve files off Apache, resursive
  mkdir /var/www/html/typo3
  chown apache:apache /var/www/html/typo3

  # Configure SELinux
  chcon -t httpd_sys_rw_content_t /var/www/html/typo3 -R # change context
  setsebool -P httpd_can_network_connect 1 # allow network connections

  # Install TYPO3 using Composer
  cd /var/www/html
  echo "Downloading TYPO3 source"
  sudo -u apache composer create-project typo3/cms-base-distribution:^11 typo3 --no-interaction --no-progress

  cd /var/www/html/typo3
  sudo -u apache composer require typo3/cms-lowlevel:^11 typo3/cms-introduction --no-interaction --no-progress

  # Redis specific
  sudo -u apache composer require b13/distributed-locks --no-interaction --no-progress

  # Dotenv specific
  sudo -u apache composer config --no-plugins allow-plugins.helhum/dotenv-connector true
  sudo -u apache composer require helhum/dotenv-connector --no-interaction --no-progress
  sudo -u apache composer dumpautoload

  # # Create an empty FIRST_INSTALL file to enable TYPO3 install tool
  sudo touch /var/www/html/typo3/public/FIRST_INSTALL

  touch "$FLAG_FILE"
fi

AUTHORIZED_KEYS="/tmp/authorized_keys"
if [ -f "${AUTHORIZED_KEYS}" ]; then
  # we create a directory and set the correct permission
  sudo -u apache mkdir -m 700 /usr/share/httpd/.ssh

  cp "${AUTHORIZED_KEYS}" /usr/share/httpd/.ssh/authorized_keys
  chown apache:apache /usr/share/httpd/.ssh/authorized_keys
  chmod 600 /usr/share/httpd/.ssh/authorized_keys

  # Make it convenient for apache user to use sudo for development purpose
  echo "apache ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/apache
fi