Redis environment for TYPO3
============================

This will create some virtual machines with redis and sentinel installed along with a web server and a graphical admin console for redis. The redis instances are configured to form a replica set with a sentinel for high availability.

```bash
git clone ...
cd typo3-redis-cluster

# Assuming you went through the local installation steps below
vagrant up
```

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
vagrant ssh master1 -- redis-cli -p 6379 DEBUG sleep 300
```

## See configuration diff

Create a diff between the vendor configuration and the current configuration

```bash
vagrant ssh master1 -- sudo diff -ru /etc/redis.conf.vendor /etc/redis.conf
vagrant ssh master1 -- sudo diff -ru /etc/redis-sentinel.conf.vendor /etc/redis-sentinel.conf

vagrant ssh replica1 -- sudo diff -ru /etc/redis.conf.vendor /etc/redis.conf
vagrant ssh replica1 -- sudo diff -ru /etc/redis-sentinel.conf.vendor /etc/redis-sentinel.conf
```

# Install - local development

We use the following tools:

- Vagrant
- As virtualization, we are using libvirt with KVM instead of virtualbox. As we are assuming a linux host, we can avoid the overhead of virtualbox. Assuming we are using Ubuntu, we can install the required packages with the following commands:

```bash
# install required packages
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients
sudo apt install vagrant

# optional, used for tailing logs in separate windows in logs/redis.sh
sudo apt install tmux

# will require a reboot
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu

# we could try this we should avoid a reboot
sudo usermod -aG libvirt $(whoami)
groups

# install vagrant properly
sudp apt install vagrant

# install additional plugins
vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-hostsupdater
```

## Troubleshoting

### hosts

Adjust the ip addresses to match the ones assigned during the boot process. We can use the following script to get the ip addresses of the VMs:

```shell
./scripts/show-ip.sh
```

We can then edit the `/etc/hosts` file and add the output of the script as example below:

```shell
192.168.109.102  web1
192.168.109.254  master1
192.168.109.189  replica1
192.168.109.191  replica2
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
    - target: `/etc/redis.conf`
    - recipe: `provision/redis/2-configure.sh`
    - Placeholder to be replaced per hosts:

```shell
# <my-ip> the ip of the current node on the lan
bind 127.0.0.1 <my-ip>

# <my-priority> between 0 and 100, the lower the higher the priority. Must be unique per node
slave-priority <my-priority>
```

* Configuration Sentinel
    - source: `./files/redis/redis-sentinel.conf`
    - target: `/usr/local/lib/node_modules/redis-commander/config/local-development.json`
    - recipe: `provision/redis/2-configure.sh`

* Configuration for graphical admin console
    - source: `./files/redis-commander/local-development.json`
    - target: `/etc/redis.conf`
    - Install the systemd service unit:
        - source: `./files/redis-commander/redis-commander.service`
        - target: `/etc/systemd/system/redis-commander.service`

## Testing

* Functional tests
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

* config to have 2 sentinels running on the same machine as we only have 2 VMs and we need 3 sentinels at least
* write a systemd service unit for redis-commander
* TYPO3 setup with redis sentinels
* firewall configuration?