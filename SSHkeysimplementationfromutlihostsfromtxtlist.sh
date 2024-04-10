#!/bin/bash

# SSH server details
username="theusrnameyouhaveaccess"
private_key="/pathto/.ssh/keys"

# New SSH key to be added
new_key="ssh-rsa something"

# Check if the hostnames file exists
hostnames_file="hostnames.txt"
if [ ! -f "$hostnames_file" ]; then
    echo "Error: Hostnames file $hostnames_file not found."
    exit 1
fi

# Flag to indicate if any hostname has been processed
processed=false

# Iterate over each hostname in the file and add the new SSH key
while IFS= read -r hostname; do
    # Attempt to connect to the hostname and check if SSH authentication is successful without prompting for a password
    if ssh -q -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no -i "$private_key" "$username"@"$hostname" exit; then
        echo "Connected to $hostname successfully without password prompt."
        # Attempt to add SSH key to the hostname
        if ssh -o BatchMode=yes -i "$private_key" "$username"@"$hostname" "printf \"%s\n\" \"$new_key\" >> /pathto/.ssh/keys"; then
            echo "New SSH key added successfully to $hostname."
        else
            echo "Failed to add SSH key to $hostname."
        fi
        processed=true
    else
        echo "Skipping $hostname as password-based authentication is required."
    fi
done < "$hostnames_file"

# Check if any hostname has been processed
if ! $processed; then
    echo "All hostnames in $hostnames_file have been processed."
fi
