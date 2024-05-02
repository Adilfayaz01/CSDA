#!/bin/bash

# Get the network interface name
interface=$(ip route | awk '$1 == "default" {print $5}')

# Get the IP address and subnet mask of the network interface
ip_info=$(ip -o -4 addr show $interface | awk '{print $4}')
ip_address=$(echo $ip_info | cut -d '/' -f 1)
subnet_mask=$(echo $ip_info | cut -d '/' -f 2)

# Calculate the network range
IFS='.' read -r -a octets <<< "$ip_address"
IFS='.' read -r -a mask_octets <<< "$subnet_mask"

network_range="${octets[0]}.${octets[1]}.${octets[2]}.$((${octets[3]} & ${mask_octets[0]})).$((${mask_octets[1]}))"

echo "$network_range/$(echo $subnet_mask)"

