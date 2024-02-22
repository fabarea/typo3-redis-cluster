Redis environment for TYPO3
============================

Start with the following commands:

```bash
git clone ...
cd typo3-redis-cluster
vagrant up
```

This will create 3 virtual machines with redis installed and configured to work as a cluster.
Make sure your system has the required packages installed. See the requirements section.

# Configuration files

The specific configuration files are located in the `files` directory and can be taken as a reference for the configuration of the redis cluster.
To be noticed the configuration of 2 services:

- redis in cluster mode
- redis-sentinel to monitor the redis cluster

We can also consider the provision of the nodes which is done in `scripts/provision.sh`. To increase the number of nodes, you can also add more machines into the `Vagrantfile`.

# Usefull commands

## Run some functional tests

```bash
./tests/1-write-and-read-data.sh
./tests/2-info-from-sentinel.sh
```

## Show the logs

```bash
./logs/redis-logs.sh
./logs/redis-sentinels-logs.sh
```

## See configuration diff

Create a diff between the vendor configuration and the current configuration

```bash
vagrant ssh master1 -- sudo diff -ru /etc/redis.conf.vendor /etc/redis.conf
vagrant ssh master1 -- sudo diff -ru /etc/redis-sentinel.conf.vendor /etc/redis-sentinel.conf

vagrant ssh slave1 -- sudo diff -ru /etc/redis.conf.vendor /etc/redis.conf
vagrant ssh slave1 -- sudo diff -ru /etc/redis-sentinel.conf.vendor /etc/redis-sentinel.conf
```

# Required packages

We use the following tools:

- Vagrant
- As virtualization, we are using libvirt with KVM instead of virtualbox. As we are assuming a linux host, we can avoid the overhead of virtualbox. Assuming we are using Ubuntu, we can install the required packages with the following commands:

```bash
# install required packages
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients
sudo apt install vagrant

# optional, used for tailing logs in separate windows in scripts/tail-redis-logs.sh
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

#  Open questions

* Is a firewall enabled in the PRD, VAL, INT environment?
* Do we require a password to connect to the redis cluster?
