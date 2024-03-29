#!/bin/bash

# List of VMs
vms=("web1" "redis1" "redis2" "redis3")

# Iterate over each VM
for vm in "${vms[@]}"; do
    # Execute the command on the VM
    ip_address=$(vagrant ssh $vm -- sudo ip a show eth1 | awk '/inet / {print $2}' | cut -f1 -d'/')

    # Display the result
    echo "$ip_address $vm"
done