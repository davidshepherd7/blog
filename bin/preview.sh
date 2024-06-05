#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
$
# Portably go to the directory that this script is in
cd "$(dirname ${BASH_SOURCE[0]})"

cd ../

SOURCE="${PWD}/src/"


# Rebuild and serve site, jekyll will watch for changes and constantly
# rebuild.
docker run --rm \
       -p 4000:4000 \
       --mount "type=bind,source=${SOURCE},dst=/srv/jekyll/src" \
       -it jekyll/jekyll:4.2.0 \
       jekyll serve --source /srv/jekyll/src --destination /srv/jekyll/build
