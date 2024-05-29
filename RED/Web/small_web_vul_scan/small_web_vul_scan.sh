#!/bin/bash

# Simple Vulnerability Scan Script
# Usage: ./vuln_scan.sh <target>

# Check if target is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <target>"
  exit 1
fi

TARGET=$1

echo "Starting vulnerability scan on $TARGET"

# Run nmap to detect open ports and services
echo "Running nmap scan..."
nmap -sV -oN nmap_scan_results.txt $TARGET

# Check if nmap scan completed successfully
if [ $? -ne 0 ]; then
  echo "Nmap scan failed."
  exit 1
fi

echo "Nmap scan completed. Results saved in nmap_scan_results.txt"

# Run nmap vulnerability scan using nmap scripts
echo "Running nmap vulnerability scan..."
nmap --script vuln -oN nmap_vuln_results.txt $TARGET

# Check if nmap vulnerability scan completed successfully
if [ $? -ne 0 ]; then
  echo "Nmap vulnerability scan failed."
  exit 1
fi

echo "Nmap vulnerability scan completed. Results saved in nmap_vuln_results.txt"

# (Optional) Run nikto web vulnerability scan if web server is detected
echo "Checking for web server on $TARGET..."

WEB_PORT=$(grep -E 'open.*http' nmap_scan_results.txt | awk '{print $1}')

if [ ! -z "$WEB_PORT" ]; then
  echo "Web server detected on port $WEB_PORT. Running Nikto scan..."
  nikto -h $TARGET -port $WEB_PORT -output nikto_scan_results.txt

  # Check if Nikto scan completed successfully
  if [ $? -ne 0 ]; then
    echo "Nikto scan failed."
    exit 1
  fi

  echo "Nikto scan completed. Results saved in nikto_scan_results.txt"
else
  echo "No web server detected. Skipping Nikto scan."
fi

echo "Vulnerability scan completed successfully."


