#!/bin/bash

# Check if CIDR notation is provided
if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 <CIDR>"
    echo "Example: $0 10.0.0.0/24"
    exit 1
fi

# Extract IP and subnet from CIDR notation
ip_address=$(echo "$1" | cut -d '/' -f 1)
subnet_mask=$(echo "$1" | cut -d '/' -f 2)

# Calculate network range
IFS='.' read -r -a octets <<< "$ip_address"
network_range="${octets[0]}.${octets[1]}.${octets[2]}.$(((${octets[3]} >> (32 - $subnet_mask)) << (32 - $subnet_mask)))"

# Ping each host in the network range
for i in $(seq 0 $((2**(32 - $subnet_mask) - 1))); do
    ip="$network_range.$i"
    if ping -c 1 -W 1 "$ip" &> /dev/null; then
        echo "Host $ip is up"
    fi
done

