#!/usr/bin/env bash

vagrant ssh redis1 -- redis-benchmark -h redis1 -p 6379