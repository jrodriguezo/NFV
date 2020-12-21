#!/bin/bash

VNF1="mn.dc1_$1-1-ubuntu-1"
VNF2="mn.dc1_$1-2-vyos-1"   # Nombre del docker VyOS. Obtener con “docker ps”

curl -X PUT -d '"tcp:$VNF1:6632"' http://$VNF1:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr

curl -X POST -d '{"port_name": "s1-eth1", "type": "linux-htb", "max_rate": "12000000", "queues": [{"max_rate": "4000000"}, {"min_rate": "8000000"}]}' http://$VNF1:8080/qos/queue/0000000000000001

curl -X POST -d '{"match": {"nw_dst": "192.168.255.1", "nw_proto": "UDP", "tp_dst": "5002"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001

curl -X GET http://localhost:8080/qos/rules/0000000000000001