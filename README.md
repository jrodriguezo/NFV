<img  align="left" width="150" style="float: left;" src="https://www.upm.es/sfs/Rectorado/Gabinete%20del%20Rector/Logos/UPM/CEI/LOGOTIPO%20leyenda%20color%20JPG%20p.png">
<img  align="right" width="60" style="float: right;" src="http://www.dit.upm.es/figures/logos/ditupm-big.gif">

<br/><br/><br/>

# Virtualized Residential Networks with OSM
> Conversion of local exchanges into data centers that allow, among other things, to replace network services offered by specific and proprietary hardware with network services defined by software on general-purpose hardware.

## About The Project

It simulates a two residential networks each composed of two computers which through a bridge controlled by Ryu from the VNF vClass for upstream traffic.

The bridge is connected through a VXLAN tunnel to the docker containers managed by OSM. The dockers simulate different network functions. One acts as a Ryu controller for downstream traffic while the other acts as a router implemented by Vyos. In turn, both are interconnected via a VXLAN tunnel.

Private network traffic is acquired via DHCP and a NAT is made for outgoing traffic to the Internet.

To start the scenario, several scripts are executed that manage the creation of two VNX networks, the use of OSM as a docker container orchestrator and the configuration of the containers themselves.

## About The Scripts
Explained in order of execution:
* **vcpe.sh**: This script puts the entire system into operation. It configures the VNF vClass and vCPE (Vyos), starts the scenarios, runs the dhclient on the hosts (to get IP) and configures the QoS.

* **vcpe_start.sh**: This script is in charge of configuring the VNF vClass. It is in charge of creating an OSM instance. Then the OVS is initialized and the veth0 port is added to connect the VNF to the AccessNet. Once this is done, the br0 switch is created where the vxlan1 and vxlan2 ports are added (for the tunnels of its ends with the residential and Vyos networks respectively) and the necessary configurations are made to be able to perform QoS on the switch.

* **vcpe_vyos.sh**: In this script is where the configurations are made regarding the VXLAN tunnel that connects to vClass, DHCP, NAT and routing. The eth2 port is added to output the container to the internet. Inside the Vyos the different configurations are added (set command), the first thing that is done is to disable the eth0 interface so that it does not use it by default as routing, since then we will put the static route that we are interested in. Then, and in order, the VXLAN is configured by adding IP addressing, the VNI, the MTU, the address that connects with vClass and a port. Later, we give address to eth2, we add the static route to give exit to internet (or any address) assigning as next jump the GW of the router R1. Then, NAT is performed where any IP address within the 192.168.255.0/24 subnet (internal interface) will be output on the eth2 (external interface). Finally, we perform the DHCP where the range assigned goes from 192.168.255.20 to 192.168.255.30. To save the changes you must execute the commit and save.

* **qos.sh**: This script configures both the upstream and downstream qualities for both residential networks. This is done using the REST API provided by Ryu. The structure of each one is composed of four curls:
   * PUT sets the ovsdb_addr to access OVSDB.
   * POST executes the queue configuration.
   * POST installs the input stream to the switch.
   * GET checks the contents of the switch configuration.

* **destroyall.sh**: To destroy the entire scenario, first the VNX instances are destroyed and then the VCPEs of the two residential networks.

## Getting Started

If you want to **run the application locally** please proceed with the following steps.

### Prerequisites on W10

The following components are necessary for the execution of the application:
* [VirtualBox](https://www.virtualbox.org/) (v6.1 tested)
* [OVA-VNXSDNNFVLAB2020-v5](http://idefix.dit.upm.es/download/vnx/vnx-vm/VNXSDNNFVLAB2020-v5.ova)

_Note: in a similar way it would be in other environments_

### Installation

1. Clone this repository.

   ```
   git clone https://github.com/jrodriguezo/NFV.git
   ```
   _Note: you can download the repository as .zip_ 

2. Access from a browser (e.g. Mozilla Firefox) to the address 127.0.0.1 and log-in with admin/admin (the password is pre-configured).

   _Note: Do not use localhost, it may not work because it is not properly configured in /etc/hosts_

      * Insert in the 'NS Packages' section the package that is inside NFV/pck called ns-vcpe.tar.gz

      * Insert in the 'VNF Packages' section the packages that are inside NFV/pck called vnf-vclass.tar.gz and vnf-vcpe-vyos.tar.gz

3. Build the docker images: vnf-img and vnf-vyos.

   ```
   cd img/vnf-img/ && sudo docker build -t vnf-img .
   ```
   ```
   cd img/vnf-vyos/ && sudo docker build -t vnf-vyos .
   ```

4. Go to the directory NFV/ where we will execute a series of commands.
   ```sh
   cd NFV/
   ```

5. Create the AccessNet and ExtNet ovs by typing the follow command:

   ```sh
   ./init.sh
   ```
   _Note1: If you get a 'permission denied' message, run 'sudo chmod +x init.sh'_
   _Note2: Run 'sudo ovs-vsctl show' to check if it was created correctly_
   
6. Check OSM and vim-emu status:

   ```sh
   osm-check-vimemu
   ```
   If the previous command does not show Status: ENABLED restart the environment with 
   ```sh
   osm-restart-vimemu
   ```
   This will take some time, check after a while (about two minutes) the previous command and check that vim-emu and OSM are started, and that the VIM called 'emu-vim' is correctly registered in OSM.
   
7. Run the script that displays the entire scenario.:

   ```sh
   ./vcpe.sh
   ```
   _Note: if during execution you see a 'permission denied' message, you must give permission to the file by 'sudo chmod +x <_file>'_
   
### Uninstall or destroy

* If you want to close or destroy the entire scenario run:

   ```sh
   ./destroyall.sh
   ```
   _Note: if during execution you see a 'permission denied' message, you must give permission to the file by 'sudo chmod +x <_file>'_
   
   
### Unexpected failures

* If it is not possible to create the VNX scenario using 

   ```sh
   sudo vnx -f vnx/nfv3_home_lxc_ubuntu64.xml -t
   ```
   delete the following directory and run it again
    ```sh
   sudo rm -rf /root/
   ```
* If the quality setting is not as expected, re-run the script associated with it
    ```sh
   ./qos.sh
   ```
   
## Testing QoS with Iperf
To test the quality of the service, here are some examples.
## DownStream: from Vyos to hxx
### Configuration
Downlink capacity: 12 Mbps

|Queue ID|Max rate  |Min rate  |
|--------|----------|----------|
|0       |4 Mbps    |-         |
|1       |-         |8 Mbps    |

|(Priority)|Destination address|Destination port|Protocol|Queue ID|(QoS ID)|
|----------|------------------------|----------------|--------|--------|--------|
|1         |192.168.255.20 (hx1)    |3000            |UDP     |1       |1       |

### Test 1
from hx1:
```sh
 iperf -s -u -i 1 -p 3000
```
 from vyos (docker exec -ti mn.dc1_vcpe-1-2-vyos-1 bash -c 'su - vyos'):
```sh
 iperf -c 192.168.255.20 -p 3000 -u -b 12M -l 1200 
```
### Test 2
from hx2: 
```sh
 iperf -s -u -i 1 -p 3000
```
 from vyos (docker exec -ti mn.dc1_vcpe-1-2-vyos-1 bash -c 'su - vyos'):
```sh
iperf -c 192.168.255.21 -p 3000 -u -b 12M -l 1200 
```
## UpStream: from hxx to Vyos
### Configuration
Uplink capacity: 6 Mbps

|Queue ID|Max rate  |Min rate  |
|--------|----------|----------|
|0       |2 Mbps    |-         |
|1       |-         |2 Mbps    |

|(Priority)|Source address|Destination port|Protocol|Queue ID|(QoS ID)|
|----------|------------------------|----------------|--------|--------|--------|
|1         |192.168.255.20 (hx1)    |7000            |UDP     |1       |1       |

### Test 1
from hxx:
```sh
 iperf -s -u -i 1 -p 7000
```
 from vyos (docker exec -ti mn.dc1_vcpe-1-2-vyos-1 bash -c 'su - vyos'):
```sh
 iperf -c 192.168.255.1 -p 7000 -u -b 12M -l 1200 
```

 _Note: To access any machine console, log in with root/xxxx_
 
## Contributors

Thanks to:
- [@jrodriguezo](https://github.com/jrodriguezo)
- [@ecalatayudc](https://github.com/ecalatayudc)
- [@xxliu95](https://github.com/xxliu95)

