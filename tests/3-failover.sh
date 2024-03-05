#!/usr/bin/env bash

# failure of "redis1"
vagrant ssh redis1 -- redis-cli DEBUG sleep 60

# failure of "redis2"
# vagrant ssh redis2 -- redis-cli DEBUG sleep 60

# failure of "redis3"
# vagrant ssh redis3 -- redis-cli DEBUG sleep 60