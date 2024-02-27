#!/bin/bash

# use full for redis-commander
yum install nodejs npm -y
npm install -g redis-commander

# Add more paths to the PATH variable
if ! grep -q "export PATH=\$PATH:/usr/local/bin" ~/.bashrc; then
    # If not present, append the line to .bashrc
    echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
fi

cp /tmp/local-development.json /usr/local/lib/node_modules/redis-commander/config/local-development.json
cp /tmp/redis-commander.service /etc/systemd/system/redis-commander.service
systemctl daemon-reload
systemctl enable redis-commander.service -q
systemctl restart redis-commander.service