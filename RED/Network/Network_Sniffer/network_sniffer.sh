#!/bin/bash

# Check if user is root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Interface to sniff
interface="eth0"

# Filter expression (optional)
filter=""

# Output file (optional)
output="captured.pcap"

# Start capturing packets
tcpdump -i $interface $filter -w $output

