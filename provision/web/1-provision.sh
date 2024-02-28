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

# will be fixed by command `vagrant hostmanager`
sudo sed -i "/^127.0.1.1 $(hostname)/c\#127.0.1.1 $(hostname)" /etc/hosts