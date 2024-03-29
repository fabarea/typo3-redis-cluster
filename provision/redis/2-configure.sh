#!/bin/bash

# #####################################
# Redis config
# #####################################

# make a backup from the original config files
[ ! -f /etc/redis.conf.vendor ] && sudo cp /etc/redis.conf /etc/redis.conf.vendor
[ ! -f /etc/redis-sentinel.conf.vendor ] && sudo cp /etc/redis-sentinel.conf /etc/redis-sentinel.conf.vendor

# copy some config files
sudo cp /tmp/redis.conf /etc/redis.conf
sudo cp /tmp/redis-sentinel.conf /etc/redis-sentinel.conf

# compute some values
ip=$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

# search / replace
sed -i "s/<my-priority>/$SLAVE_PRIORITY/" /etc/redis.conf
sed -i "s/<my-ip>/$ip/" /etc/redis.conf
if [ "$IS_REPLICA" == true ]; then
  sed -i "s/# replicaof redis1 6379/replicaof redis1 6379/" /etc/redis.conf
fi

# Restart services
sudo systemctl restart redis
sudo systemctl restart redis-sentinel

# Possibly install the second instance of sentinel
if [ -f /tmp/redis-sentinel-26380.conf ]; then
  sudo cp /tmp/redis-sentinel-26380.conf /etc/redis-sentinel-26380.conf
  cp /tmp/redis-sentinel-26380.service /etc/systemd/system/redis-sentinel-26380.service
  systemctl daemon-reload
  systemctl enable redis-sentinel-26380.service -q
  # systemctl restart redis-sentinel-26380.service
fi