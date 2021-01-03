#!/bin/bash

###################### HomeInet 1 ######################
#desde h11:
#iperf -s -u -i 1 -p 3000
#desde vyos (docker exec -ti mn.dc1_vcpe-1-2-vyos-1 bash -c 'su - vyos'):
#iperf -c 192.168.255.20 -p 3000 -u -b 12M -l 1200 

#desde h12: 
#iperf -s -u -i 1 -p 3000
#desde vyos:
#iperf -c 192.168.255.21 -p 3000 -u -b 12M -l 1200 

IP_H11=`sudo lxc-attach --name h11 -- ifconfig eth1 | grep "inet " | awk '{print $2}'`
IP_H12=`sudo lxc-attach --name h12 -- ifconfig eth1 | grep "inet " | awk '{print $2}'`
echo "IP H11: $IP_H11"
echo "IP H12: $IP_H12"

curl -X PUT -d '"tcp:10.255.0.1:6632"' http://172.17.0.2:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr
curl -X POST -d '{"port_name": "vxlan1", "type": "linux-htb", "max_rate": "12000000", "queues": [{"max_rate": "4000000"}, {"min_rate": "8000000"}]}' http://172.17.0.2:8080/qos/queue/0000000000000001
curl -X POST -d '{"match": {"nw_dst": "$IP_H11", "nw_proto": "UDP", "tp_dst": "3000"}, "actions":{"queue": "1"}}' http://172.17.0.2:8080/qos/rules/0000000000000001
curl -X GET http://172.17.0.2:8080/qos/rules/0000000000000001

#desde vyos: 
#iperf -s -u -i 1 -p 7000
#desde h11 o h12:
#iperf -c 192.168.255.1 -p 7000 -u -b 12M -l 1200

curl -X PUT -d '"tcp:10.255.0.2:6632"' http://172.17.0.2:8080/v1.0/conf/switches/0000000000000002/ovsdb_addr
curl -X POST -d '{"port_name": "vxlan1", "type": "linux-htb", "max_rate": "6000000", "queues": [{"max_rate": "2000000"}, {"min_rate": "2000000"}]}' http://172.17.0.2:8080/qos/queue/0000000000000002
curl -X POST -d '{"match": {"nw_src": "$IP_H11", "nw_proto": "UDP", "tp_dst": "7000"}, "actions":{"queue": "1"}}' http://172.17.0.2:8080/qos/rules/0000000000000002
curl -X GET http://172.17.0.2:8080/qos/rules/0000000000000002


###################### HomeInet 2 ######################

IP_H21=`sudo lxc-attach --name h21 -- ifconfig eth1 | grep "inet " | awk '{print $2}'`
IP_H12=`sudo lxc-attach --name h22 -- ifconfig eth1 | grep "inet " | awk '{print $2}'`
echo "IP H21: $IP_H21"
echo "IP H22: $IP_H22"

curl -X PUT -d '"tcp:10.255.0.3:6632"' http://172.17.0.2:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr
curl -X POST -d '{"port_name": "vxlan1", "type": "linux-htb", "max_rate": "12000000", "queues": [{"max_rate": "4000000"}, {"min_rate": "8000000"}]}' http://172.17.0.2:8080/qos/queue/0000000000000001
curl -X POST -d '{"match": {"nw_dst": "$IP_H21", "nw_proto": "UDP", "tp_dst": "3000"}, "actions":{"queue": "1"}}' http://172.17.0.2:8080/qos/rules/0000000000000001
curl -X GET http://172.17.0.2:8080/qos/rules/0000000000000001


curl -X PUT -d '"tcp:10.255.0.4:6632"' http://172.17.0.2:8080/v1.0/conf/switches/0000000000000002/ovsdb_addr
curl -X POST -d '{"port_name": "vxlan1", "type": "linux-htb", "max_rate": "6000000", "queues": [{"max_rate": "2000000"}, {"min_rate": "2000000"}]}' http://172.17.0.2:8080/qos/queue/0000000000000002
curl -X POST -d '{"match": {"nw_src": "$IP_H21", "nw_proto": "UDP", "tp_dst": "7000"}, "actions":{"queue": "1"}}' http://172.17.0.2:8080/qos/rules/0000000000000002
curl -X GET http://172.17.0.2:8080/qos/rules/0000000000000002