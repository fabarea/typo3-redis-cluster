#!/usr/bin/env bash

nodes=(
    "master1"
    "slave1"
    "slave2"
)
commands=(
    # "sentinel master my-cluster"
    "sentinel get-master-addr-by-name my-cluster"
    # "sentinel sentinels my-cluster"
)

for node in "${nodes[@]}"; do
    for command in "${commands[@]}"; do
        echo ""
        echo "Info from sentinel node \"$node\""
        vagrant ssh "$node" -- redis-cli -p 26379 "$command"
    done
done