#!/usr/bin/env bash

value="hello-world..."
echo "writing data, value: \"${value}\""
vagrant ssh redis1 -- redis-cli set hello ${value}

nodes=("redis1" "redis2" "redis3")

for node in "${nodes[@]}"
do
    echo ''
    echo "reading data from \"$node\""
    output=$(vagrant ssh "$node" -- redis-cli get hello)
    [ "${output}" == "${value}" ] && echo "👍 ${output}" || echo "⛔ ${output} (failure)"
done
