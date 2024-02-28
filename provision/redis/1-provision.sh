#!/bin/bash

sudo yum install -y epel-release
sudo yum install -y redis
sudo yum install -y nano

# Start and enable Redis service
sudo systemctl start redis
sudo systemctl enable redis -q

# Start and enable Redis Sentinel service
sudo systemctl start redis-sentinel
sudo systemctl enable redis-sentinel -q

# Allow Redis to be accessible from outside (for testing purposes)
#sudo firewall-cmd --permanent --zone=public --add-port=6379/tcp
#sudo firewall-cmd --permanent --zone=public --add-service=ssh
##sudo firewall-cmd --permanent --zone=public --add-service=icmp
#sudo firewall-cmd --permanent --zone=public --add-icmp-block=echo-request
#sudo firewall-cmd --reload

# we deactivate the firewall for testing purposes
sudo systemctl stop firewalld
sudo systemctl disable firewalld -q

# will be fixed by command `vagrant hostmanager`
sudo sed -i "/^127.0.1.1 $(hostname)/c\#127.0.1.1 $(hostname)" /etc/hosts