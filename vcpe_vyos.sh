#!/bin/bash

USAGE="
Usage:
    
vcpe_start <vcpe_name> <vnf_vni> <vcpe_public_ip> <vcpe_private_ip>
    being:
        <vcpe_name>: the name of the network service instance in OSM 
        <vnf_vni>: the vni for the vnf side of the tunnel
        <vcpe_public_ip>: the public ip address for the vcpe
        <vcpe_private_ip>: the public ip address for the vcpe  
"

VNF1="mn.dc1_$1-1-ubuntu-1"
VNF2="mn.dc1_$1-2-vyos-1"   # Nombre del docker VyOS. Obtener con “docker ps”
VNI="$2"
VCPEPUBLICIP="$3"
VCPEPRIVATEIP="$4"
HNAME='vyos'

REMOTEIP=`sudo docker exec -it $VNF1 hostname -I | tr " " "\n" | grep 192.168.100`

sudo ovs-docker add-port ExtNet eth2 $VNF2

docker exec -ti $VNF2 /bin/bash -c "
source /opt/vyatta/etc/functions/script-template
ifconfig eth0 down
configure
set system host-name $HNAME
set interfaces vxlan vxlan1 address $VCPEPRIVATEIP/24
set interfaces vxlan vxlan1 vni $VNI
set interfaces vxlan vxlan1 mtu 1400
set interfaces vxlan vxlan1 remote $REMOTEIP
set interfaces vxlan vxlan1 port 8472
set interfaces ethernet eth2 address $VCPEPUBLICIP/24
set protocols static route 0.0.0.0/0 next-hop 10.2.3.254
set nat source rule 100 outbound-interface eth2
set nat source rule 100 source address 192.168.255.0/24
set nat source rule 100 translation address masquerade
set service dhcp-server shared-network-name main authoritative
set service dhcp-server shared-network-name main subnet 192.168.255.0/24 default-router $VCPEPRIVATEIP
set service dhcp-server shared-network-name main subnet 192.168.255.0/24 lease 86400
set service dhcp-server shared-network-name main subnet 192.168.255.0/24 range 0 start 192.168.255.20
set service dhcp-server shared-network-name main subnet 192.168.255.0/24 range 0 stop 192.168.255.30
commit
save
exit
"

