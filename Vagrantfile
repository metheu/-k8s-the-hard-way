# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
box_name = "bento/rockylinux-8.6"

# Machine Config
base_ip = 10
base_ip_addresses = "192.168.56"
number_of_machines = 5
vm_name = "node"
vm_mem = 2048

ip_addresses = (1..number_of_machines).map{ |i| "#{base_ip_addresses}.#{base_ip + i}" }

    script = <<-SCRIPT
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3rVWC6Mta8J9UqB+9H52h1GCefDC60gjZtqIgM12fkv3SgBKBWzvE0HQM9ueJ9LZnIf2CH2IOIHmGWmyvArShv73kb+GKmzO1mdeViJUAD96rMxkiB30glAwugBInza6HUaLY13kqzMg9LjVHHjsjhtLjAdEDMcRhzV4vifo1FC0EbJt/n/TU2oDiT7AjUM6DPwtCYzfXVKgyBDxSWYryix1I8IqFdKE80wEGetWV71SFgS1HCwLyFqUSEAdjx1S6At6dFEB+n6FoTdSU/NJzbafn7aHx4pld+RWWoWH+tLdeOABLG+JogXvhXweUTfIv1yPyNKJTDfde+mR5DDbW+pmE/NxBZGhmIDSXUtYhcK0E6MIkm/7XIywyYoOsCryVld7rcd03h+RoP2EZuZLG4ab86xdhI6uU+pDEKImqAYHHDqf9szKY0qFSIKqc9tC2rqPW2GfKJFRexLqG3OzwsWiU7GEzfVYV033B/xDLIeDKull9XthfvIIY9gYJprpelLuS9I09c2KswdEYc9nx0/fTTb2L3/r/63Aag4IM1YGImLhsKlJ8sJ8h56CiX5grCwxmVw1lFjmE2a+RBui1UwOmC21Sdus0/cR1DYwyJME7hoeGu7RDi0QYDA6+JY895lf0y/bnECvJVDqgRzhOHj9s4U6Tslt4UrALOU104Q== matt@Matthews-MBP.root.sx" >> /home/vagrant/.ssh/authorized_keys
    sudo systemctl restart sshd.service
    SCRIPT

    config.landrush.enabled = true
    config.vm.provider "virtualbox" do |v|
        v.memory = "#{vm_mem}"
    end

    (1..number_of_machines).each do |i|
      config.vm.define "#{vm_name}#{i}" do |box|
        box.vm.box = "#{box_name}"
        box.vm.hostname = "#{vm_name}#{i}.vagrant.test"
        box.vm.network "private_network", ip: "#{ip_addresses[i-1]}"

        box.vm.provision "shell", inline: "#{script}"
      end
    end
end
