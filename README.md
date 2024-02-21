# typo3-redis-cluster

Start with the following commands:

```bash
git clone
cd typo3-redis-cluster
vagrant up
```

This will create 3 virtual machines with redis installed and configured to work as a cluster.

## Requirements

- Vagrant
- We are using libvirt with KVM as virtualization instead of virtualbox. As we are using a linux host, we can avoid the overhead of virtualbox. Assuming we are using Ubuntu, we can install the required packages with the following commands:

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

## Configuration files

The configuration is done in the Vagrantfile. You can change the number of nodes, the memory, the cpu, the ip, etc.



## Usefull commands

```bash
./scripts/tail-redis-logs.sh
```

# Test cases

```bash
./tests/1-write-and-read-data.sh
```

#  Open questions

* Is a firewall enabled in the PRD, VAL, INT environment?
* Do we require a password to connect to the redis cluster?

# Todos

* create a diff of the config files

```bash
diff -ru files/master1/redis.vendor.conf files/master1/redis.conf
diff -ru files/master1/redis-sentinel.vendor.conf files/master1/redis-sentinel.conf
diff -ru files/slave1/redis.vendor.conf files/slave1/redis.conf
diff -ru files/slave1/redis-sentinel.vendor.conf files/slave1/redis-sentinel.conf
diff -ru files/slave2/redis.vendor.conf files/slave2/redis.conf
diff -ru files/slave2/redis-sentinel.vendor.conf files/slave2/redis-sentinel.conf
```