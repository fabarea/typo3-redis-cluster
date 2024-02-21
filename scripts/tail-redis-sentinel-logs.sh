#!/bin/bash
tmux \
    new-session  'vagrant ssh master1 -- sudo tail -f /var/log/redis/sentinel.log' \; \
    split-window 'vagrant ssh slave1 -- sudo tail -f /var/log/redis/sentinel.log' \; \
    split-window 'vagrant ssh slave2 -- sudo tail -f /var/log/redis/sentinel.log' \; \
    select-layout even-vertical
