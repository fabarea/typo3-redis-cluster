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
    node.vm.box = "generic/centos9s" # "generic/ubuntu2204" # "generic/debian12"
    node.vm.hostname = "web1"

    # specific provider configuration
    configure_network(node)

    # copy template to "web1"
    node.vm.provision "file", source: "files/web/nginx-default.conf", destination: "/tmp/default.conf"
    node.vm.provision "file", source: "files/web/dot_env", destination: "/tmp/.env"
    node.vm.provision "file", source: "files/web/AdditionalConfiguration.php", destination: "/tmp/AdditionalConfiguration.php"

    node.vm.provision "shell", path: "provision/web/1-provision.sh"
    node.vm.provision "shell", path: "provision/typo3/1-typo3.sh"
    node.vm.provision "shell", path: "provision/typo3/2-configure.sh"
  end

  # ###################################
  # master1
  # ###################################
  config.vm.define "master1" do |node|
    node.vm.box = "generic/centos7"
    node.vm.hostname = "master1"

    # specific provider configuration
    configure_network(node)

    # copy template to "master1"
    node.vm.provision "file", source: "files/redis/redis.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel.conf", destination: "/tmp/redis-sentinel.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel-26379.conf", destination: "/tmp/redis-sentinel-26379.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel-26379.service", destination: "/tmp/redis-sentinel-26379.service"
    node.vm.provision "file", source: "files/redis-commander/local-development.json", destination: "/tmp/local-development.json"
    node.vm.provision "file", source: "files/redis-commander/redis-commander.service", destination: "/tmp/redis-commander.service"

    # Provisioning "master1"
    node.vm.provision "shell", path: "provision/redis/1-provision.sh"
    node.vm.provision "shell", path: "provision/redis/2-configure.sh", env: { SLAVE_PRIORITY: 50 }
    node.vm.provision "shell", path: "provision/redis/3-redis-commander.sh"
  end

  # ###################################
  # replica1
  # ###################################
  config.vm.define "replica1" do |node|
    node.vm.box = "generic/centos7"
    node.vm.hostname = "replica1"

    # specific provider configuration
    configure_network(node)

    # copy template to "replica1"
    node.vm.provision "file", source: "files/redis/redis.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel.conf", destination: "/tmp/redis-sentinel.conf"

    # Provisioning "replica1"
    node.vm.provision "shell", path: "provision/redis/1-provision.sh"
    node.vm.provision "shell", path: "provision/redis/2-configure.sh", env: { IS_REPLICA: true, SLAVE_PRIORITY: 75 }
  end

  # ###################################
  # replica2
  # ###################################
  config.vm.define "replica2" do |node|
    node.vm.box = "generic/centos7"
    node.vm.hostname = "replica2"

    # specific provider configuration
    configure_network(node)

    # copy template to "replica2"
    node.vm.provision "file", source: "files/redis/redis.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel.conf", destination: "/tmp/redis-sentinel.conf"

    # Provisioning "replica2"
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
    # other options: :nfs, :rsync, :9p, :virtfs
    # node.vm.synced_folder "./typo3", "/var/www/html/typo3", type: "nfs"
    # node.vm.synced_folder "./typo3", "/var/www/html/typo3", type: "rsync" # unidirectonal

    # libvirt specific
    if ENV['VAGRANT_DEFAULT_PROVIDER'] == 'libvirt'
      node.vm.network :public_network, :dev => 'eno1', :mode => "bridge"
      # https://discuss.hashicorp.com/t/vagrants-synced-folders-over-nfs-do-not-work-with-libvirt-provider/33262/1
      # config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ["vers=3,tcp"] # libvirt specialty
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
