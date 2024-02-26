#!/usr/bin/env bash

# failure of "master1"
vagrant ssh master1 -- redis-cli DEBUG sleep 60

# failure of "replica1"
# vagrant ssh replica1 -- redis-cli DEBUG sleep 60

# failure of "replica2"
# vagrant ssh replica2 -- redis-cli DEBUG sleep 60