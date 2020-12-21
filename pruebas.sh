#!/bin/bash

VNF1="mn.dc1_vcpe-1-1-ubuntu-1"


echo http://$VNF1:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr


ETH1=`sudo docker exec -it $VNF1 ifconfig | grep eth1 | awk '{print substr($1, 1, length($1)-1)}'` 

echo $ETH1