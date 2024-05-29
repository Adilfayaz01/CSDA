#!/bin/bash

# Function to extract and print user information
list_users() {
    awk -F: '$3 >= 1000 && $1 != "nobody" { print $1 }' /etc/passwd
}

# Function to count failed login attempts for a user
count_failed_login_attempts() {
    local user="$1"
    local attempts=$(grep "Failed password for $user" /var/log/auth.log* | wc -l)
    echo "$user - $attempts"
}

# Main script
main() {
    local output_file="failed_login_attempts.txt"

    echo "Detecting failed login attempts for all users..."
    echo "Generating output file: $output_file"

    # Remove the output file if it already exists
    [ -f "$output_file" ] && rm "$output_file"

    # List all users and count their failed login attempts
    while IFS= read -r user; do
        count_failed_login_attempts "$user" >> "$output_file"
    done < <(list_users)

    echo "Done!"
}

# Call the main function
main

