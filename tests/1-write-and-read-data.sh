#!/usr/bin/env bash

value="hello-world..."
echo "writing data to master, value: \"${value}\""
vagrant ssh master1 -- redis-cli set hello ${value}

nodes=("master1" "replica1" "replica2")

for node in "${nodes[@]}"
do
    echo ''
    echo "reading data from \"$node\""
    output=$(vagrant ssh "$node" -- redis-cli get hello)
    [ "${output}" == "${value}" ] && echo "👍 ${output}" || echo "⛔ ${output} (failure)"
done
