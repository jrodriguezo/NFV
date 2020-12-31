FROM ubuntu:bionic

#geographic area
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install required packages
RUN apt-get clean
RUN apt-get update \
    && apt-get install -y  git \
    net-tools \
    aptitude \
    build-essential \
    python-setuptools \
    python-dev \
    python-pip \
    software-properties-common \
    ansible \
    curl \
    iptables \
    iputils-ping \
    iproute2 \
    sudo \
    nano \
    bridge-utils \
    isc-dhcp-server \
    tcpdump \
    openvswitch-switch \
    iperf3 \
    vim \
    tzdata \
    ryu-bin 

RUN sed '/OFPFlowMod(/,/)/s/)/, table_id=1)/' /usr/lib/python3/dist-packages/ryu/app/simple_switch_13.py > /usr/lib/python3/dist-packages/ryu/app/qos_simple_switch_13.py


#RUN ovs-vsctl set Bridge br0 protocols=OpenFlow13
#RUN ovs-vsctl set-manager ptcp:6632
#RUN ovs-vsctl set bridge br0 other-config:datapath-id=0000000000000001
#RUN ovs-vsctl set-controller br0 tcp:172.17.0.2:6633

#WORKDIR /usr/lib/python3/dist-packages/ryu/app/

#RUN ryu-manager ryu.app.rest_qos ryu.app.qos_simple_switch_13 ryu.app.rest_conf_switch

#RUN curl -X PUT -d '"tcp:127.0.0.1:6632"' http://172.17.0.2:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr
#RUN curl -X POST -d '{"port_name": "vxlan2", "type": "linux-htb", "max_rate": "12000000", "queues": [{"max_rate": "4000000"}, {"min_rate": "8000000"}]}' http://172.17.0.2:8080/qos/queue/0000000000000001
#RUN curl -X POST -d '{"match": {"nw_dst": "10.2.2.2", "nw_proto": "UDP", "tp_dst": "5002"}, "actions":{"queue": "1"}}' http://172.17.0.2:8080/qos/rules/0000000000000001
#RUN curl -X GET http://172.17.0.2:8080/qos/rules/0000000000000001

#COPY dhcpd.conf /etc/dhcp/dhcpd.conf
#COPY isc-dhcp-server /etc/default/isc-dhcp-server

#Install isc-dhcp-server
#RUN apt-get update
#RUN apt-get install isc-dhcp-server 
#RUN apt-get update
#RUN apt-get install isc-dhcp-relay

# open ports
# IPERF3
EXPOSE 5201
# IPERF3
EXPOSE 3000
# IPERF3
EXPOSE 7000

EXPOSE 6632
EXPOSE 8080
