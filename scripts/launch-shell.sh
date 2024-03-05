#!/bin/bash

tmux \
    new-session  'vagrant ssh web1' \; \
    split-window 'vagrant ssh redis1' \; \
    split-window 'vagrant ssh redis2' \; \
    split-window 'vagrant ssh redis3' \; \
    select-layout even-vertical
