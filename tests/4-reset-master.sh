#!/usr/bin/env bash

# failure of "redis1"
vagrant ssh redis1 -- redis-cli -p 26379 SENTINEL RESET mymaster

# failure of "redis2"
vagrant ssh redis2 -- redis-cli -p 26379 SENTINEL RESET mymaster

# failure of "redis3"
vagrant ssh redis3 -- redis-cli -p 26379 SENTINEL RESET mymaster