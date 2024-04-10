#!/bin/bash

# SSH server details
username="theusrnameyouhaveaccess"
private_key="/pathto/.ssh/keys"

# SSH keys file
keys_file="/pathto/ssh_keys.txt"

# Check if the hostnames file exists
hostnames_file="hostnames.txt"
if [ ! -f "$hostnames_file" ]; then
    echo "Error: Hostnames file $hostnames_file not found."
    exit 1
fi

# Check if the SSH keys file exists
if [ ! -f "$keys_file" ]; then
    echo "Error: SSH keys file $keys_file not found."
    exit 1
fi

# Iterate over each hostname in the file and add the new SSH keys
while IFS= read -r hostname; do
    echo "Processing $hostname..."
    
    # Check if SSH connection can be established
    if ssh -q -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no -i "$private_key" "$username"@"$hostname" exit; then
        echo "Connected to $hostname successfully."
        
        # Iterate over each SSH key in the keys file and add them
        while IFS= read -r key; do
            # Attempt to add SSH key to the hostname
            if ssh -o BatchMode=yes -i "$private_key" "$username"@"$hostname" "printf \"%s\n\" \"$key\" >> /pathto/.ssh/authorized_keys"; then
                echo "SSH key added successfully to $hostname."
            else
                echo "Failed to add SSH key to $hostname."
            fi
        done < "$keys_file"
    else
        echo "Error: Failed to connect to $hostname."
    fi
done < "$hostnames_file"

echo "All hostnames in $hostnames_file have been processed."
