#!/bin/bash

# Check if the user is attempting to run the passwd command
if [[ "$1" == "passwd" ]]; then
    echo "Changing password is not allowed."
    exit 1
fi

# If not, allow the command to execute
"$@"

