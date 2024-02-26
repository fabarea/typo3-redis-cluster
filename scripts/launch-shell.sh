#!/bin/bash

tmux \
    new-session  'vagrant ssh web1' \; \
    split-window 'vagrant ssh master1' \; \
    split-window 'vagrant ssh slave1' \; \
    split-window 'vagrant ssh slave2' \; \
    select-layout even-vertical
