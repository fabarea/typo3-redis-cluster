#!/bin/bash

tmux \
    new-session  'vagrant ssh redis1 -- sudo tail -f /var/log/redis/redis.log' \; \
    split-window 'vagrant ssh redis2 -- sudo tail -f /var/log/redis/redis.log' \; \
    split-window 'vagrant ssh redis3 -- sudo tail -f /var/log/redis/redis.log' \; \
    select-layout even-vertical
