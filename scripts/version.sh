#!/usr/bin/env bash

curl -sSL https://api.github.com/repos/Wind4/vlmcsd/tags | jq -r '.[0].name'
