# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "centos/8"
MEMORY = "1536"
CPU = "2"

Vagrant.configure("2") do |config|
  config.vm.define "node1" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "node1"
	subconfig.vm.network :private_network, ip: "192.168.56.111"
	#Make some changes to the elasticsearch.yml file and start the service
	subconfig.vm.provision "shell",
      inline: <<-SHELL 
		sudo su
		sed -i 's/#cluster.name: my-application/cluster.name: ElasticserchCluster/g' /etc/elasticsearch/elasticsearch.yml
		sed -i 's/#node.name: node-1/node.name: node1/g' /etc/elasticsearch/elasticsearch.yml
		sed -i 's/#network.host: 192.168.0.1/network.host: ["192.168.56.111", "localhost"]/g' /etc/elasticsearch/elasticsearch.yml
		echo 'discovery.seed_hosts: ["192.168.56.111", "192.168.56.112", "192.168.56.113"]' >>  /etc/elasticsearch/elasticsearch.yml
		echo 'cluster.initial_master_nodes: ["192.168.56.111", "192.168.56.112"]' >>  /etc/elasticsearch/elasticsearch.yml
		echo 'node.master: true' >>  /etc/elasticsearch/elasticsearch.yml
		echo 'node.data: false' >>  /etc/elasticsearch/elasticsearch.yml
		echo -e "\e[1;31mElasticsearch needs some time to start so please be patient...\e[0m"
		systemctl start elasticsearch.service
	  SHELL
	subconfig.vm.provider :virtualbox do |vb|
          vb.customize ["modifyvm", :id, "--memory", MEMORY]
          vb.customize ["modifyvm", :id, "--cpus", CPU]
	end
  end
  config.vm.define "node2" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "node2"
	subconfig.vm.network :private_network, ip: "192.168.56.112"
	#Make some changes to the elasticsearch.yml file and start the service
	subconfig.vm.provision "shell",
      inline: <<-SHELL 
		sudo su
		sed -i 's/#cluster.name: my-application/cluster.name: ElasticserchCluster/g' /etc/elasticsearch/elasticsearch.yml
		sed -i 's/#node.name: node-1/node.name: node2/g' /etc/elasticsearch/elasticsearch.yml
		sed -i 's/#network.host: 192.168.0.1/network.host: ["192.168.56.112", "localhost"]/g' /etc/elasticsearch/elasticsearch.yml
		echo 'discovery.seed_hosts: ["192.168.56.111", "192.168.56.112", "192.168.56.113"]' >>  /etc/elasticsearch/elasticsearch.yml
		echo 'cluster.initial_master_nodes: ["192.168.56.111", "192.168.56.112"]' >>  /etc/elasticsearch/elasticsearch.yml
		echo 'node.master: true' >>  /etc/elasticsearch/elasticsearch.yml
		echo -e "\e[1;31mElasticsearch needs some time to start so please be patient...\e[0m"
		systemctl start elasticsearch.service
	  SHELL
	subconfig.vm.provider :virtualbox do |vb|
          vb.customize ["modifyvm", :id, "--memory", MEMORY]
          vb.customize ["modifyvm", :id, "--cpus", CPU]
	end
  end
  config.vm.define "node3" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "node3"
	subconfig.vm.network :private_network, ip: "192.168.56.113"
	#Make some changes to the elasticsearch.yml file and start the service
	subconfig.vm.provision "shell",
      inline: <<-SHELL 
		sudo su
		sed -i 's/#cluster.name: my-application/cluster.name: ElasticserchCluster/g' /etc/elasticsearch/elasticsearch.yml
		sed -i 's/#node.name: node-1/node.name: node3/g' /etc/elasticsearch/elasticsearch.yml
		sed -i 's/#network.host: 192.168.0.1/network.host: ["192.168.56.113", "localhost"]/g' /etc/elasticsearch/elasticsearch.yml
		echo 'discovery.seed_hosts: ["192.168.56.111", "192.168.56.112", "192.168.56.113"]' >>  /etc/elasticsearch/elasticsearch.yml
		echo 'cluster.initial_master_nodes: ["192.168.56.111", "192.168.56.112"]' >>  /etc/elasticsearch/elasticsearch.yml
		echo 'node.master: true' >>  /etc/elasticsearch/elasticsearch.yml	
		echo -e "\e[1;31mElasticsearch needs some time to start so please be patient...\e[0m"		
		systemctl start elasticsearch.service
		echo -e "\e[1;31mKibana needs some time to start so please be patient...\e[0m"
		rpm --install /vagrant/kibana-7.15.2-x86_64.rpm
		sed -i 's/#server.host: "localhost"/server.host: "192.168.56.113"/g' /etc/kibana/kibana.yml
		/bin/systemctl daemon-reload
		/bin/systemctl enable kibana.service
		/bin/systemctl start kibana.service
	  SHELL
	subconfig.vm.provider :virtualbox do |vb|
          vb.customize ["modifyvm", :id, "--memory", MEMORY]
          vb.customize ["modifyvm", :id, "--cpus", CPU]
	end
  end
  # Install Elasticsearch on all machines and install some extra additional packages 
  config.vm.provision "shell", inline: <<-SHELL
	sudo su
	sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config    
    systemctl restart sshd.service
	yum -y install nano
	yum -y install net-tools
	rpm --install /vagrant/elasticsearch-7.15.2-x86_64.rpm
	/bin/systemctl daemon-reload
	/bin/systemctl enable elasticsearch.service
  SHELL
end