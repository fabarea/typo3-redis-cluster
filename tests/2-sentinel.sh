#!/usr/bin/env bash

nodes=(
    "redis1"
    "redis2"
    "redis3"
)
commands=(
    # "sentinel master mymaster"
    "sentinel get-master-addr-by-name mymaster"
    # "sentinel sentinels mymaster"
)

for node in "${nodes[@]}"; do
    for command in "${commands[@]}"; do
        echo ""
        echo "Info from sentinel node \"$node\""
        vagrant ssh "$node" -- redis-cli -p 26379 "$command"
    done
done