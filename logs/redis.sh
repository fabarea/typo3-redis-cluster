#!/bin/bash

tmux \
    new-session  'vagrant ssh master1 -- sudo tail -f /var/log/redis/redis.log' \; \
    split-window 'vagrant ssh replica1 -- sudo tail -f /var/log/redis/redis.log' \; \
    split-window 'vagrant ssh replica2 -- sudo tail -f /var/log/redis/redis.log' \; \
    select-layout even-vertical
