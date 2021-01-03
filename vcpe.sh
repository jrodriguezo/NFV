#!/bin/bash

#sudo chmod +x vcpe_vyos.sh

# cd Desktop/trabajo/NFV
# ./init.sh
# sudo ovs-vsctl show
# osm-check-vimemu
# osm-restart-vimemu

./vcpe_start.sh vcpe-1 10.255.0.1 10.255.0.2
./vcpe_start.sh vcpe-2 10.255.0.3 10.255.0.4 

./vcpe_vyos.sh vcpe-1 10.2.3.1 192.168.255.1
./vcpe_vyos.sh vcpe-2 10.2.3.2 192.168.255.1 

sudo vnx -f vnx/nfv3_home_lxc_ubuntu64.xml -t 
sudo vnx -f vnx/nfv3_server_lxc_ubuntu64.xml -t 

#sudo lxc-attach --clear-env -n h11 -- bash -c \"dhclient\"
#sudo lxc-attach --clear-env -n h12 -- bash -c \"dhclient\"
sudo lxc-attach --name h11 -- dhclient
sudo lxc-attach --name h12 -- dhclient
sudo lxc-attach --name h21 -- dhclient
sudo lxc-attach --name h22 -- dhclient


./qos.sh