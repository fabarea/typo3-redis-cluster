#!/bin/bash

FLAG_FILE="/etc/vagrant_provisioned"

# Only once...
if [ ! -f "$FLAG_FILE" ]; then

  curl -sL https://rpm.nodesource.com/setup_18.x | bash -
  yum install nodejs -y
  npm install -g npm@latest
  npm install -g redis-commander

  cp /tmp/local-development.json /usr/lib/node_modules/redis-commander/config/local-development.json
  cp /tmp/redis-commander.service /etc/systemd/system/redis-commander.service
  systemctl daemon-reload
  systemctl enable redis-commander.service -q
  systemctl restart redis-commander.service

  touch "$FLAG_FILE"
fi
