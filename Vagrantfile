Vagrant.configure("2") do |config|

  # ###################################
  # master1
  # ###################################
  config.vm.define "master1" do |node|
    node.vm.box = "generic/centos7"
    node.vm.hostname = "master1"
    node.vm.network "private_network", type: "dhcp"
    node.vm.provider :libvirt do |libvirt|
      libvirt.driver = "kvm"
    end

    # Provisioning "master1"
    node.vm.provision "shell", path: "scripts/provision.sh"
    node.vm.provision "file", source: "files/redis/master/redis.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel.conf", destination: "/tmp/redis-sentinel.conf"
    node.vm.provision "shell", path: "scripts/provision-post-install.sh"
  end

  # ###################################
  # slave1
  # ###################################
  config.vm.define "slave1" do |node|
    node.vm.box = "generic/centos7"
    node.vm.hostname = "slave1"
    node.vm.network "private_network", type: "dhcp"
    node.vm.provider :libvirt do |libvirt|
      libvirt.driver = "kvm"
    end

    # Provisioning "slave1"
    node.vm.provision "shell", path: "scripts/provision.sh"
    node.vm.provision "file", source: "files/redis/slave/redis.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel.conf", destination: "/tmp/redis-sentinel.conf"
    node.vm.provision "shell", path: "scripts/provision-post-install.sh"
  end


  # ###################################
  # slave2
  # ###################################
  config.vm.define "slave2" do |node|
    node.vm.box = "generic/centos7"
    node.vm.hostname = "slave2"
    node.vm.network "private_network", type: "dhcp"
    node.vm.provider :libvirt do |libvirt|
      libvirt.driver = "kvm"
    end

    # Provisioning "slave2"
    node.vm.provision "shell", path: "scripts/provision.sh"
    node.vm.provision "file", source: "files/redis/slave/redis.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel.conf", destination: "/tmp/redis-sentinel.conf"
    node.vm.provision "shell", path: "scripts/provision-post-install.sh"
  end
end
