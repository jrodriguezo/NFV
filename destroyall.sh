#!/bin/bash

sudo vnx -f vnx/nfv3_home_lxc_ubuntu64.xml -P
sudo vnx -f vnx/nfv3_server_lxc_ubuntu64.xml -P

./vcpe_destroy.sh vcpe-1
./vcpe_destroy.sh vcpe-2
