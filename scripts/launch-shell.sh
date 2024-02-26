#!/bin/bash

tmux \
    new-session  'vagrant ssh web1' \; \
    split-window 'vagrant ssh master1' \; \
    split-window 'vagrant ssh replica1' \; \
    split-window 'vagrant ssh replica2' \; \
    select-layout even-vertical
