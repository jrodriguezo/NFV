#!/bin/bash

#VNF3="mn.dc1_$1-1-brgX-1"

#VNFBRGTUNIP="$2" #10.255.0.2
#VNFVCLASSTUNIP="$3" #10.255.0.1

#sudo ovs-docker add-port AccessNet veth0 $VNF1

#sudo docker exec -it $VNF1 ovs-vsctl add-br br0
#sudo docker exec -it $VNF1 ifconfig veth0 $VNFBRGTUNIP/24
#sudo docker exec -it $VNF1 ip link add vxlan1 type vxlan id 0 remote $VNFVCLASSTUNIP dstport 4789 dev veth0
#sudo docker exec -it $VNF1 ovs-vsctl add-port br0 vxlan1
#sudo docker exec -it $VNF1 ifconfig vxlan1 up

#sudo docker exec -it $VNF1 ovs-vsctl add-port br0 eth1
#sudo docker exec -it $VNF1 ifconfig eth1 up


sed '/OFPFlowMod(/,/)/s/)/, table_id=1)/' /usr/lib/python3/dist-packages/ryu/app/simple_switch_13.py > qos_simple_switch_13.py

ryu-manager ryu.app.rest_qos ryu.app.rest_conf_switch ./qos_simple_switch_13.py