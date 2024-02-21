#!/bin/bash

# if file does not exist, make a backup
if [ ! -f /etc/redis.conf.bak ]; then
    sudo cp /etc/redis.conf /etc/redis.conf.bak
fi

# same as above but in one line
[ ! -f /etc/redis.conf.vendor ] && sudo cp /etc/redis.conf /etc/redis.conf.vendor
[ ! -f /etc/redis-sentinel.conf.vendor ] && sudo cp /etc/redis-sentinel.conf /etc/redis-sentinel.conf.vendor

# copy some config files
sudo cp /tmp/redis.conf /etc/redis.conf
sudo cp /tmp/redis-sentinel.conf /etc/redis-sentinel.conf

# Restart services
sudo systemctl restart redis
sudo systemctl restart redis-sentinel