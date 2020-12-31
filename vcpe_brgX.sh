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

# antes de hacer el dhclient es necesario que el ryu-manager esté corriendo

#sed '/OFPFlowMod(/,/)/s/)/, table_id=1)/' /usr/lib/python3/dist-packages/ryu/app/simple_switch_13.py > qos_simple_switch_13.py

#ryu-manager ryu.app.rest_qos ryu.app.rest_conf_switch ./qos_simple_switch_13.py

#hacer los curls en un terminal a parte

# curl -X PUT -d '"tcp:127.0.0.1:6632"' http://10.250.0.22:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr
# curl -X POST -d '{"port_name": "vxlan1", "type": "linux-htb", "max_rate": "6000000", "queues": [{"max_rate": "2000000"}, {"min_rate": "2000000"}]}' http://10.250.0.22:8080/qos/queue/0000000000000001
# curl -X POST -d '{"match": {"nw_dst": "192.168.255.1", "nw_proto": "UDP", "tp_dst": "3000"}, "actions":{"queue": "1"}}' http://10.250.0.22:8080/qos/rules/0000000000000001
### curl -X POST -d '{"match": {"nw_dst": "192.168.255.1", "nw_proto": "UDP", "udp_dst": "3000"}, "actions":{"queue": "1"}}' http://10.250.0.22:8080/qos/rules/0000000000000001
# curl -X GET http://10.250.0.22:8080/qos/rules/0000000000000001