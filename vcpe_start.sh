#!/bin/bash

osm ns-create --ns_name vcpe-1 --nsd_name vCPE --vim_account emu-vim && echo "Initializing, wait 30s" && sleep 30

USAGE="
Usage:
    
vcpe_start <vcpe_name> <vnf_tunnel_ip> <home_tunnel_ip> 
    being:
        <vcpe_name>: the name of the network service instance in OSM 
        <vnf_tunnel_ip>: the ip address for the vnf side of the tunnel
        <home_tunnel_ip>: the ip address for the home side of the tunnel
"

if [[ $# -ne 3 ]]; then
        echo ""       
    echo "ERROR: incorrect number of parameters"
    echo "$USAGE"
    exit 1
fi

VNF1="mn.dc1_$1-1-ubuntu-1"
VNF2="mn.dc1_$1-2-vyos-1"

VNFTUNIP="$2"  
HOMETUNIP="$3"

IP21=`sudo docker exec -it $VNF2 hostname -I | awk '{printf "%s\n", $1}{print $2}' | grep 192.168.100`
ETH1=`sudo docker exec -it $VNF1 ifconfig | grep eth1 | awk '{print substr($1, 1, length($1)-1)}'` 

##################### VNF Setting #####################
## 0. Iniciar el Servicio OpenVirtualSwitch en cada VNF:
echo "--"
echo "--OVS Starting..."
sudo docker exec -it $VNF1 /usr/share/openvswitch/scripts/ovs-ctl start

echo "--"
echo "--Connecting vCPE service with AccessNet and ExtNet..."

sudo ovs-docker add-port AccessNet veth0 $VNF1

echo "--"
echo "--Setting VNF..."
echo "--"
echo "--Bridge Creating..."

sudo docker exec -it $VNF1 ovs-vsctl add-br br0
sudo docker exec -it $VNF1 ifconfig veth0 $VNFTUNIP/24
sudo docker exec -it $VNF1 ip link add vxlan1 type vxlan id 0 remote $HOMETUNIP dstport 4789 dev veth0
sudo docker exec -it $VNF1 ip link add vxlan2 type vxlan id 1 remote $IP21 dstport 8472 dev $ETH1
sudo docker exec -it $VNF1 ovs-vsctl add-port br0 vxlan1
sudo docker exec -it $VNF1 ovs-vsctl add-port br0 vxlan2
sudo docker exec -it $VNF1 ifconfig vxlan1 up
sudo docker exec -it $VNF1 ifconfig vxlan2 up

echo "--"
echo "--Configuring QoS..."

sudo docker exec -it $VNF1 ovs-vsctl set Bridge br0 protocols=OpenFlow13
sudo docker exec -it $VNF1 ovs-vsctl set-manager ptcp:6632
sudo docker exec -it $VNF1 ovs-vsctl set bridge br0 other-config:datapath-id=0000000000000001
sudo docker exec -it $VNF1 ovs-vsctl set-controller br0 tcp:172.17.0.2:6633

sudo docker exec -d $VNF1 /bin/bash -c "cd /usr/lib/python3/dist-packages && ryu-manager ryu.app.rest_qos ryu.app.qos_simple_switch_13 ryu.app.rest_conf_switch"