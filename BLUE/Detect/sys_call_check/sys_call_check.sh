#!/bin/bash

# Check if the command is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <command>"
    exit 1
fi

# Command to trace system calls
command="$@"

# Trace system calls for 10 seconds
echo "Tracing system calls for '$command' for 10 seconds..."
strace -o trace_output.txt -Tttt -e trace=%process -p $(pgrep "$command") &

# Sleep for 10 seconds
sleep 10

# Kill the strace process
kill $(pgrep strace)

# Display the results
echo "System calls made by '$command' for the last 10 seconds:"
echo "==============================================="
echo "PID | Application/Tool"
echo "-----------------------------------------------"
awk '/\<process>/ {print $2, "|", $NF}' trace_output.txt | sort -u > system_calls_output.txt

echo "Results saved to system_calls_output.txt"

# Remove the trace file
rm trace_output.txt

