Vagrant.configure("2") do |config|


  # ###################################
  # web1
  # ###################################
  config.vm.define "web1" do |node|
    node.vm.box = "generic/centos9s" # "generic/ubuntu2204" # "generic/debian12"
    node.vm.hostname = "web1"

    # Connect to the public network
    #node.vm.network 'public_network', bridge: 'wlp2s0' # with VirtualBox
    node.vm.network :public_network, :dev => 'eno1', :mode => "bridge"

    # Libvirt specific
    node.vm.provider :libvirt do |libvirt|
      libvirt.driver = "kvm"
    end

    node.vm.provision "shell", path: "provision/web/provision.sh"
    node.vm.provision "shell", path: "provision/apps/typo3.sh"
    node.vm.provision "file", source: "files/web/nginx-default.conf", destination: "/tmp/default.conf"
    node.vm.provision "file", source: "files/web/dot_env", destination: "/tmp/.env"
    node.vm.provision "file", source: "files/web/AdditionalConfiguration.php", destination: "/tmp/AdditionalConfiguration.php"
    node.vm.provision "shell", path: "provision/web/provision-post.sh"
    # replace the php value max_execution_time = 30 to be max_execution_time = 300

    # VirtualBox spcific
    # node.vm.provider :virtualbox do |vb|
    #   vb.memory = "1024"
    # end
    # other options: :nfs, :rsync, :9p, :virtfs
    # https://vagrant-libvirt.github.io/vagrant-libvirt/examples.html
    # other options: :nfs, :rsync, :9p, :virtfs
    # node.vm.synced_folder "./typo3", "/var/www/html/typo3", type: "nfs"
    # node.vm.synced_folder "./typo3", "/var/www/html/typo3", type: "rsync" # unidirectonal

    # https://discuss.hashicorp.com/t/vagrants-synced-folders-over-nfs-do-not-work-with-libvirt-provider/33262/1
    # config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ["vers=3,tcp"] # libvirt specialty
  end

  # ###################################
  # master1
  # ###################################
  config.vm.define "master1" do |node|
    node.vm.box = "generic/centos7"
    node.vm.hostname = "master1"
    # Connect to the public network
    node.vm.network :public_network, :dev => 'eno1', :mode => "bridge"
    node.vm.provider :libvirt do |libvirt|
      libvirt.driver = "kvm"
    end

    # Provisioning "master1"
    node.vm.provision "shell", path: "provision/redis/provision.sh"
    node.vm.provision "shell", path: "provision/apps/redis-commander.sh"
    node.vm.provision "file", source: "files/redis/master/redis.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel.conf", destination: "/tmp/redis-sentinel.conf"
    node.vm.provision "file", source: "files/redis-commander/local-development.json", destination: "/tmp/local-development.json"
    node.vm.provision "shell", path: "provision/redis/provision-post.sh"
  end

  # ###################################
  # replica1
  # ###################################
  config.vm.define "replica1" do |node|
    node.vm.box = "generic/centos7"
    node.vm.hostname = "replica1"
    node.vm.provider :libvirt do |libvirt|
      libvirt.driver = "kvm"
    end

    # Provisioning "replica1"
    node.vm.provision "shell", path: "provision/redis/provision.sh"
    node.vm.provision "file", source: "files/redis/replica/redis.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel.conf", destination: "/tmp/redis-sentinel.conf"
    node.vm.provision "shell", path: "provision/redis/provision-post.sh"
  end

  # ###################################
  # replica2
  # ###################################
  config.vm.define "replica2" do |node|
    node.vm.box = "generic/centos7"
    node.vm.hostname = "replica2"
    node.vm.provider :libvirt do |libvirt|
      libvirt.driver = "kvm"
    end

    # Provisioning "replica2"
    node.vm.provision "shell", path: "provision/redis/provision.sh"
    node.vm.provision "file", source: "files/redis/replica/redis.conf", destination: "/tmp/redis.conf"
    node.vm.provision "file", source: "files/sentinel/redis-sentinel.conf", destination: "/tmp/redis-sentinel.conf"
    node.vm.provision "shell", path: "provision/redis/provision-post.sh"
  end
end
