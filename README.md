Redis environment for TYPO3
============================

This will create some virtual machines with redis and sentinel installed along with a web server and a graphical admin console for redis. The redis instances are configured to form a replica set with a sentinel for high availability.

```bash
git clone ...
cd typo3-redis-cluster

# Assuming you went through the local installation steps below
vagrant up

# Update the hosts file in the guest machines
vagrant hostmanager
```

# Install - local development

You can install the required packages and plugins with the following commands:

```bash
# virtualbox is a bit more common and has less edge cases
# on local development when it comes to networking and file sharing.
# virtualization with libvirt and KVM is also possible, see below
sudo apt install virtualbox
sudo apt install vagrant

# optional, used for tailing logs in separate windows in logs/redis.sh
sudo apt install tmux

# install vagrant properly
sudp apt install vagrant

# install additional plugins
vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-hostmanager
```

As an alternative, we can virtualize with libvirt and KVM instead of virtualbox. However, we need a network connection with ethernet to obtain a public ip addresses for the VMs to connect on the lan. This will not work over wifi as a driver limitation.

```shell
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients

# will require a reboot
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu

# we could try this we should avoid a reboot
sudo usermod -aG libvirt $(whoami)
groups
```

# Install - production

## Package dependencies and configuration

* Required packages
    - redis
        - recipe: `provision/redis/1-provision.sh`
    - php-redis
        - recipe: `provision/web/1-provision.sh`
    - node, npm, redis-commander
        - recipe: `provision/redis/3-redis-commander.sh`
* Configuration Redis
    - source: `./files/redis/redis.conf`
      target: `/etc/redis.conf`
    - recipe: `provision/redis/2-configure.sh`
    - Placeholder to be replaced per hosts:

```shell
# <my-ip> the ip of the current node on the lan
bind 127.0.0.1 <my-ip>

# <my-priority> between 0 and 100, the lower the higher the priority. Must be unique per node
slave-priority <my-priority>
```

* Configuration Redis Sentinel
    - source: `./files/redis/redis-sentinel.conf`
      target: `/etc/redis-sentinel.conf`
    - recipe: `provision/redis/2-configure.sh`

* Configuration Redis Commender (graphical admin console)
    - source: `./files/redis-commander/local-development.json`
      target: `/usr/lib/node_modules/redis-commander/config/local-development.json`
    - Install the systemd service unit:
        - source: `./files/redis-commander/redis-commander.service`
          target: `/etc/systemd/system/redis-commander.service`

* Inspect the respective logs

```shell
journalctl -feu redis
journalctl -feu redis-sentinel
journalctl -feu redis-commander
```

## Caveats

In order to provide high availability in redis, we need to have at least 3 sentinels. Sentinels are used to monitor the redis instances and to promote a new master in case of failure. To reach a quorum, we need at least 3 instances. In the conext of 2 VMs, we can set up 2 sentinels on each VM.

We can make use of the additional config files provided by

* source: `./files/sentinel/redis-sentinel-26380.conf`
  target: `/etc/redis-sentinel-26380.conf`

## Testing

* Functional tests. Scripts need to be adjusted in production context.
    - `./tests/0-benchmark.sh`
    - `./tests/1-write-and-read-data.sh`
    - `./tests/2-sentinel.sh`
    - `./tests/3-failover.sh`
* Memory usage with typo3
    - to be executed when typo3 with redis is running

##  Open questions

* Is a firewall enabled between VMs in PRD, VAL, INT ?
    - Port:
        - 6379 redis
        - 26379 sentinel
        - 8081 redis-commander (admin console for redis)
* Do we require a password to connect to the redis replica-set?

##  Todo

* TYPO3 setup with redis sentinels

```php
public/typo3/sysext/core/Classes/Cache/Backend/RedisBackend.php

$sentinel = new \RedisSentinel('redis1', 26379, 2.5);
$masterName = 'mymaster';
[$masterIp, $masterPort] = $sentinel->getMasterAddrByName($masterName);
$this->hostname = $masterIp;
$this->port = $masterPort;


public/typo3conf/ext/distributed_locks/src/RedisLockingStrategy.php
```

* TYPO3 user.ini to save browser sessions in redis instead of file cookies

```shell
  sed -i 's/session.save_handler = files/session.save_handler = redis/g' /etc/php.ini
  sed -i 's#;session.save_path = "/tmp"#session.save_path = "tcp://redis1:6379"#g' /etc/php.ini
  https://www.thisprogrammingthing.com/2017/migrating-sessions-in-php/
  https://docs.typo3.org/m/typo3/reference-coreapi/main/en-us/ApiOverview/SessionStorageFramework/SessionStorage.html
```

* To be tested https://packagist.org/packages/b13/graceful-cache
  We don't want our websites to be down because the cache backend used, e.g. "redis" or "memcached" has a temporary issue. For this reason, we provide Cache Backends which simply catch all Exceptions.

* Redis with password configuration required?

# Useful commands

## Run some functional tests

This should be executed after the VMs are up and running. We write and read data, test the sentinel.

```bash
./tests/0-benchmark.sh
./tests/1-write-and-read-data.sh
./tests/2-sentinel.sh
```

## Show the logs

This will tail the logs of the redis instances and the sentinels. We can see the failover in action.

```bash
./logs/redis.sh
./logs/sentinels.sh
```

## Simulate a fail over

For better insight, it is advisable to open the logs in separate windows (cf. commands above). We can then simulate a failover by stopping the master. We should see sentinel detecting the failure and promoting a new master.

```shell
vagrant ssh redis1 -- redis-cli -p 6379 DEBUG sleep 300
```

## See configuration diff

Create a diff between the vendor configuration and the current configuration

```bash
vagrant ssh redis1 -- sudo diff -ru /etc/redis.conf.vendor /etc/redis.conf
vagrant ssh redis1 -- sudo diff -ru /etc/redis-sentinel.conf.vendor /etc/redis-sentinel.conf

vagrant ssh redis2 -- sudo diff -ru /etc/redis.conf.vendor /etc/redis.conf
vagrant ssh redis2 -- sudo diff -ru /etc/redis-sentinel.conf.vendor /etc/redis-sentinel.conf
```

## Packaging redis-commander

```shell
sudo su -
npm install -g npm-pack-all
cd /usr/lib/node_modules/redis-commander
npm-pack-all

# create a tarball
tar -czvf redis-commander.tar.gz /usr/lib/node_modules/redis-commander

# deploy the npm package "offline"
npm install redis-commander.tar.gz
```