#!/bin/bash

VNF1="mn.dc1_vcpe-2-1-ubuntu-1"


#echo http://$VNF1:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr


#ETH1=`sudo docker exec -it $VNF1 ifconfig | grep eth1 | awk '{print substr($1, 1, length($1)-1)}'` 

#echo $ETH1

#H11=`sudo lxc-attach --name h11 -- `
#echo $H11

#sudo lxc-attach --name h11 -- dhclient
#sudo lxc-attach --name h12 -- dhclient
#sudo lxc-attach --clear-env -n h21 -- bash -c \"dhclient\"
#sudo lxc-attach --name h22 -- dhclient


ETH1=`sudo docker exec -it $VNF1 ifconfig eth0 | grep "inet " | awk '{print $2}'` 

echo $ETH1
#./qos.sh