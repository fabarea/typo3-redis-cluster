#!/bin/bash

# Update package repositories
# echo "Updating package repositories"
# dnf update -y

# Install Apache, MySQL, PHP, and other dependencies
echo "Installing Nginx, MySQL, PHP, and other dependencies"
dnf install -y epel-release
dnf install -y unzip curl nano git util-linux-user \
  nginx \
  php-fpm \
  mariadb-server \
  php \
  php-mysqli \
  php-cli  \
  php-common \
  php-zip \
  php-gd \
  php-mbstring \
  php-curl \
  php-xml \
  php-bcmath \
  php-soap \
  php-ldap \
  php-redis \
  composer

# Start and enable services
systemctl start nginx
systemctl enable nginx -q
systemctl start mariadb
systemctl enable mariadb -q
systemctl start php-fpm
systemctl enable php-fpm -q
systemctl stop firewalld
systemctl disable firewalld -q

# Alternative: allow HTTP and HTTPS traffic
#sudo firewall-cmd --permanent --add-service=http
#sudo firewall-cmd --permanent --add-service=https

# Set MySQL root password
mysqladmin -u root password "root"

# Enable apache shell for development purpose
chsh -s /bin/bash apache

# Install TYPO3 dependencies
echo "Installing TYPO3 specific dependencies"
yum install -y ImageMagick GraphicsMagick ghostscript

# Just for enabling composer caching
mkdir /usr/share/httpd/{.composer,.vim}
chown apache:apache /usr/share/httpd/{.composer,.vim}

# SELinux serve files off Apache, resursive
mkdir /var/www/html/typo3
chown apache:apache /var/www/html/typo3

# Configure SELinux
sudo chcon -t httpd_sys_rw_content_t /var/www/html/typo3 -R # change context
sudo setsebool -P httpd_can_network_connect 1 # allow network connections

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
sudo -u apache touch /var/www/html/typo3/public/FIRST_INSTALL