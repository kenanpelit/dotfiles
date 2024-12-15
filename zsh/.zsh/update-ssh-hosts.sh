#!/bin/bash
assh config list | grep -v '^#' | grep -v '^$' | awk '{print $1}' | sort > ~/.cache/assh/hosts
