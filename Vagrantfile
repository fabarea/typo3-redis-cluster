Vagrant.configure("2") do |config|

  #config.vm.provider "libvirt"
  config.vm.provider "virtualbox"

  # plugin: hostmanager
  # must comes at the end, so that the network is up and running
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  # ###################################
  # web1
  # ###################################
  config.vm.define "web1" do |node|
    node.vm.box = "generic/centos9s" # "generic/rocky9"
    node.vm.hostname = "web1"

    # specific provider configuration
    configure_network(node)

    # copy template to "web1"
    node.vm.provision "file", source: "files/web/nginx-default.conf", destination: "/tmp/default.conf"
    node.vm.provision "file", source: "files/web/dot_env", destination: "/tmp/.env"
    node.vm.provision "file", source: "files/web/AdditionalConfiguration.php", destination: "/tmp/AdditionalConfiguration.php"
    node.vm.provision "file", source: "files/ssh/authorized_keys", destination: "/tmp/authorized_keys" if File.exist?("files/ssh/authorized_keys")

    node.vm.provision "shell", path: "provision/web/1-provision.sh"
    node.vm.provision "shell", path: "provision/typo3/1-typo3.sh"
    node.vm.provision "shell", path: "provision/typo3/2-configure.sh"

    # add 6gb of memory
    node.vm.provider "virtualbox" do |v|
      v.memory = 6144
    end

  end

  # ###################################
  # redis1
  # ###################################
  config.vm.define "redis1" do |node|
    node.vm.box = "generic/centos8"
    node.vm.hostname = "redis1"

    # specific provider configuration
    configure_network(node)

    # copy template to "redis1"
    node.vm.provision "file", source: "files/redis/redis-v5.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel-v5.conf", destination: "/tmp/redis-sentinel.conf"
    node.vm.provision "file", source: "files/redis-commander/local-development.json", destination: "/tmp/local-development.json"
    node.vm.provision "file", source: "files/redis-commander/redis-commander.service", destination: "/tmp/redis-commander.service"

    # Provisioning "redis1"
    node.vm.provision "shell", path: "provision/redis/1-provision.sh"
    node.vm.provision "shell", path: "provision/redis/2-configure.sh", env: { SLAVE_PRIORITY: 50 }
    node.vm.provision "shell", path: "provision/redis/3-redis-commander.sh"
  end

  # ###################################
  # redis2
  # ###################################
  config.vm.define "redis2" do |node|
    node.vm.box = "generic/centos8"
    node.vm.hostname = "redis2"

    # specific provider configuration
    configure_network(node)

    # copy template to "redis2"
    node.vm.provision "file", source: "files/redis/redis-v5.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel-v5.conf", destination: "/tmp/redis-sentinel.conf"

    # Provisioning "redis2"
    node.vm.provision "shell", path: "provision/redis/1-provision.sh"
    node.vm.provision "shell", path: "provision/redis/2-configure.sh", env: { IS_REPLICA: true, SLAVE_PRIORITY: 75 }
  end

  # ###################################
  # redis3
  # ###################################
  config.vm.define "redis3" do |node|
    node.vm.box = "generic/centos8"
    node.vm.hostname = "redis3"

    # specific provider configuration
    configure_network(node)

    # copy template to "redis3"
    node.vm.provision "file", source: "files/redis/redis-v5.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel-v5.conf", destination: "/tmp/redis-sentinel.conf"

    # Provisioning "redis3"
    node.vm.provision "shell", path: "provision/redis/1-provision.sh"
    node.vm.provision "shell", path: "provision/redis/2-configure.sh", env: { IS_REPLICA: true, SLAVE_PRIORITY: 100 }
  end

  # ###################################
  # Helper to resolve the ip address bound to eth1
  # ###################################
  config.hostmanager.ip_resolver = proc do |machine|
    result = ""
    machine.communicate.execute("ip address show eth1") do |type, data|
      result << data if type == :stdout
    end

    ip_match = /inet (\d+\.\d+\.\d+\.\d+)/.match(result)
    if ip_match
      ip_match[1]
      #resolved_ip
    else
      machine.ui.warn("Failed to resolve IP address for eth1.")
      nil
    end
  end

  # ###################################
  # Helper for networking and shared folders
  # ###################################
  def configure_network(node)

    # will add and additional network interface to the VM, eth1
    # maybe required for virtualbox to explicitly create a private netowk.
    # libvirt would create it automatically
    # node.vm.network "private_network", type: "dhcp"

    # VirtualBox specific
    node.vm.network :public_network, bridge: "wlp110s0"

    # libvirt specific
    if ENV['VAGRANT_DEFAULT_PROVIDER'] == 'libvirt'
      node.vm.network :public_network, :dev => 'eno1', :mode => "bridge"
      node.vm.provider :libvirt do |libvirt|
        libvirt.driver = "kvm"
      end
    end

    #config.vm.provider "virtualbox" do |v|
    #  v.customize ["modifyvm", :id, "--memory", 4092, "--cpus", 2, "--name", "foo"]
    #end

    # handle the /etc/hosts file
    node.vm.provision :shell, inline: 'sed -i "/^127.0.1.1 $(hostname)/c\#127.0.1.1 $(hostname)" /etc/hosts'
    node.vm.provision :hostmanager
  end
end
