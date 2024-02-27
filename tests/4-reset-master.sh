#!/usr/bin/env bash

# failure of "master1"
vagrant ssh master1 -- redis-cli -p 26379 SENTINEL RESET mymaster

# failure of "replica1"
vagrant ssh replica1 -- redis-cli -p 26379 SENTINEL RESET mymaster

# failure of "replica2"
vagrant ssh replica2 -- redis-cli -p 26379 SENTINEL RESET mymaster