# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

cluster = {
"master.example.local" => { :ip => "196.168.121.20", :cpus => 2, :mem => 2048, :boxname => "bento/ubuntu-16.04", :provider => "virtualbox", :playbook => "provisioners/playbook_master.yml" },
 "node1.example.local" => {  :ip => "196.168.121.21", :cpus => 2, :mem => 2048, :boxname => "bento/ubuntu-16.04", :provider => "virtualbox", :playbook => "provisioners/playbook.yml" },
"node2.example.local" => {  :ip => "196.168.121.22", :cpus => 2, :mem => 2048, :boxname => "bento/ubuntu-16.04", :provider => "virtualbox", :playbook => "provisioners/playbook.yml" }
}
 
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  cluster.each_with_index do |(hostname, info), index|
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :box
    end
    if Vagrant.has_plugin?("vagrant-hostmanager")
        config.hostmanager.enabled = false
    end
    
    config.vm.base_mac = nil # random mac addresses
    config.vm.define hostname do |cfg|
      
      cfg.vm.hostname = hostname
      cfg.hostsupdater.aliases = [hostname]
      cfg.vm.box = "#{info[:boxname]}" 
      

      cfg.vm.provider :"#{info[:provider]}" do |prov|
        prov.memory = info[:mem] || '512'
        prov.cpus = info[:cpus] || '1'
        unless info[:disk2].nil?
                file_to_disk = './disks/'+hostname+'_second_disk.vdi'
                unless File.exist?(file_to_disk)
                        prov.customize  ['createhd', '--filename', file_to_disk, '--size', info[:disk2]]
                end
                prov.customize  ['storageattach', :id, '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
                
        end # add second disk
        prov.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        prov.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        prov.customize ["modifyvm", :id, "--ioapic", "on"]
        
        
      end # end provider
      
      
      
      
      unless info[:ip].nil?
        cfg.vm.network "private_network", ip: "#{info[:ip]}" 
      else
        cfg.vm.network "private_network", type: "dhcp"
      end 
      unless info[:forwarded_port_host].nil? || info[:forwarded_port_guest].nil?
        cfg.vm.network "forwarded_port", guest: "#{info[:forwarded_port_guest]}", host: "#{info[:forwarded_port_host]}"
      end
      # end network 

      unless info[:rsync].nil?
        cfg.gatling.rsync_on_startup = info[:rsync]
      end # enable disable rsync on startup

      unless info[:script].nil?
        cfg.vm.provision "shell" do |shell|
          shell.path  = "#{info[:script]}"
        end 
      end # end shell provisioner
      
      unless info[:playbook].nil?
        cfg.vm.provision "ansible" do |ansible|
          ansible.playbook  = "#{info[:playbook]}"
        end 
      end # end Ansible provisioner

   
    end # end config
  config.vm.provision :hostmanager
  end # end cluster
end
