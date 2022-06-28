
### kubernetes the hard way: Resources

This repository holds a set of resources that aid in the creation of resources used to go over the kubernetes the hard way tutorial. This has been adpated from various sources, mainly ([kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way) and [kubernetes-the-hard-way-on-bare-metal](https://medium.com/@DrewViles/kubernetes-the-hard-way-on-bare-metal-vms-fdb32bc4fed0)) 

#### tools used:
* [vagrant](https://www.vagrantup.com/)
* [vagrant-landrush plugin](https://github.com/vagrant-landrush/landrush)
* VirutalBox

### machine set-up

There is a Vagrantfile which is currently set up to create 5 machines - one that will serve as loadbalancer for the api and kube workload, 2 masters and 2 worker nodes. The number can be adjusted accordingly. 

To lauch the machines simply run:

`vagrant up`

To create the certificates needed you can use the handy script `cert_init.sh`. Please tweak accordinlgy. 




#### kubernetes app versions
 * etcd v3.4.15
 * kubernetes v1.21.0
 * containerd v1.4.4
 * cni v0.9.1