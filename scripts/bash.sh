#!/bin/bash

tmux \
    new-session  'vagrant ssh master1' \; \
    split-window 'vagrant ssh slave1' \; \
    split-window 'vagrant ssh slave2' \; \
    split-window 'vagrant ssh web1' \; \
    select-layout even-vertical
