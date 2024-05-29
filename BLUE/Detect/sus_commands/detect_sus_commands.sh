#!/bin/bash

# Define the suspicious commands
SUSPICIOUS_COMMANDS=(
    "rm -rf"
    "wget"
    "curl"
    "nc"
    "nmap"
    "chmod 777"
    "chown root"
    "sudo"
    "scp"
    "ssh"
    "dd if="
    "mkfs"
    "useradd"
    "groupadd"
    "iptables"
)

# Function to extract and print user information
list_users() {
    echo "Listing users with suspicious commands:"
    awk -F: '{ print $1 }' /etc/passwd
}

# Function to extract and save suspicious commands for a user
save_user_commands() {
    local user="$1"
    local output_file="$user.txt"
    local commands="$(grep -E "$(IFS="|"; echo "${SUSPICIOUS_COMMANDS[*]}")" /home/$user/.bash_history | tail -n 50)"

    if [ -n "$commands" ]; then
        echo "Saving suspicious commands for user: $user"
        echo "$commands" > "$output_file"
    fi
}

# Main script
main() {
    # Create a directory to store user command history files
    local output_dir="user_commands_suspicious"
    mkdir -p "$output_dir"

    # List all users and save their suspicious commands
    while IFS= read -r user; do
        save_user_commands "$user"
        if [ -f "$user.txt" ]; then
            mv "$user.txt" "$output_dir/"
        fi
    done < <(list_users)
}

# Call the main function
main

