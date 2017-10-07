#!/usr/bin/env bash

tmp=$(mktemp)

cat > $tmp < /dev/stdin

(~/.neomutt/open-multipart $tmp; rm $tmp) &
