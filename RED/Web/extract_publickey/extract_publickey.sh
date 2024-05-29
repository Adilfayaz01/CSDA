#!/bin/bash

# Function to get the public key from a server
get_public_key() {
    local hostname=$1
    local port=$2
    local output_file=$3

    # Connect to the server, retrieve the certificate, and extract the public key
    echo | openssl s_client -servername "$hostname" -connect "$hostname:$port" 2>/dev/null | \
        openssl x509 -pubkey -noout > "$output_file"

    if [[ $? -eq 0 ]]; then
        echo "Public key saved to $output_file"
    else
        echo "Failed to retrieve the public key"
    fi
}

# Main script execution
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <domain> [port]"
    exit 1
fi

hostname=$1
port=${2:-443}  # Default to port 443 if not specified
output_file="${hostname}_public_key.txt"

get_public_key "$hostname" "$port" "$output_file"

