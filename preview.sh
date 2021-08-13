#!/bin/bash

set -o errexit
set -o nounset

# Kill old jekyll
pkill jekyll -9 || echo "No old jekyll"

# Open site in 2 seconds (when jekyll is up)
sleep 2s && firefox http://localhost:4000/ &

# Rebuild and serve site, jekyll will watch for changes and constantly
# rebuild.
jekyll serve --host 127.0.0.1
