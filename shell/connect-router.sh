#!/bin/bash
# link the network
sudo iwconfig eth1 essid "TL-WR340G";
sudo dhcpcd eth1;
