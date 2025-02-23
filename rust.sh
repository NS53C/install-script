#!/bin/bash

# Make sure an IP address is provided
if [ -z "$1" ]; then
    echo -e "\033[0;31mUsage: $0 <IP address> <output file>\033[0m"
    exit 1
fi

# Check if a filename is provided
if [ -z "$2" ]; then
    echo -e "\033[0;31mUsage: $0 <IP address> <output file>\033[0m"
    exit 1
fi

IP=$1
OUTPUT_FILE=$2

# Step 1: Run the basic RustScan scan to find all open ports
echo -e "\033[0;34mRunning initial RustScan on $IP...\033[0m"
open_ports=$(sudo rustscan -a $IP | grep -oP '\d+(?=/)' | sort -u | tr '\n' ',')

# Step 2: Remove the last comma from the list of ports
open_ports=$(echo $open_ports | sed 's/,$//')

# Check if any open ports were found
if [ -z "$open_ports" ]; then
    echo -e "\033[0;31mNo open ports found.\033[0m"
    exit 2
fi

# Step 3: Run the second RustScan scan on the open ports with -A flag
echo -e "\033[0;34mRunning detailed RustScan on open ports: $open_ports\033[0m"
sudo rustscan -p$open_ports -a $IP -- -A -oN $OUTPUT_FILE

# Step 4: Inform the user about the output file location
echo -e "\033[0;32mScan results saved to $OUTPUT_FILE\033[0m"
