#!/bin/bash

# avoid error message such as dpkg-preconfigure: unable to re-open stdin: No such file or directory
export DEBIAN_FRONTEND=noninteractive

# Update package repositories
echo "Updating package repositories"
apt-get update -y -qqq

apt-get install -y -qqq nala \

# Install Apache, MySQL, PHP, and other dependencies
echo "Installing Nginx, MySQL, PHP, and other dependencies"
apt-get install -y -qqq unzip curl nala \
  nginx \
  php-fpm \
  mariadb-server \
  php \
  php-mysqli \
  php-cli  \
  php-common \
  php-mysql  \
  php-zip  \
  php-gd \
  php-mbstring \
  php-curl \
  php-xml  \
  php-bcmath \
  php-soap \
  php-ldap \
  composer

# Set MySQL root password
debconf-set-selections <<< 'mariadb-server mysql-server/root_password password root'
debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again password root'

# Install TYPO3 dependencies
echo "Installing TYPO3 specific dependencies"
apt-get install -y -qqq imagemagick graphicsmagick ghostscript

# Download and install TYPO3

# Change to the web root directory
cd /var/www/html

# Install TYPO3 using Composer
echo "Downloading TYPO3 source"
composer create-project typo3/cms-base-distribution:^11 typo3 --no-interaction --no-progress -q

cd /var/www/html/typo3
composer require typo3/cms-lowlevel:^11 typo3/cms-introduction helhum/typo3-console --no-interaction --no-progress -q

# Create an empty FIRST_INSTALL file to enable TYPO3 install tool
touch /var/www/html/typo3/public/FIRST_INSTALL

# Set permissions
chown -R www-data:www-data /var/www/html