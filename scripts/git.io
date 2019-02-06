#!/bin/bash

curl --silent --include --url http://git.io --form "url=$1" \
  | awk '/^Location:/ {print $2}'
