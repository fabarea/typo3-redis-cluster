#!/bin/bash
tmux \
    new-session  'vagrant ssh redis1 -- sudo tail -f /var/log/redis/sentinel.log' \; \
    split-window 'vagrant ssh redis2 -- sudo tail -f /var/log/redis/sentinel.log' \; \
    split-window 'vagrant ssh redis3 -- sudo tail -f /var/log/redis/sentinel.log' \; \
    select-layout even-vertical
