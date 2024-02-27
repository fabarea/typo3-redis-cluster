#!/usr/bin/env bash

vagrant ssh master1 -- redis-benchmark -h master1 -p 6379