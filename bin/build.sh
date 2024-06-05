#!/bin/bash

set -o errexit
set -o nounset


# Portably go to the directory that this script is in
cd "$(dirname ${BASH_SOURCE[0]})"

cd ../

SOURCE="${PWD}/src/"
DEST="${PWD}/build/"

docker run --rm \
       -p 4000:4000 \
       --mount "type=bind,source=${SOURCE},dst=/srv/jekyll/src" \
       --mount "type=bind,source=${DEST},dst=/srv/jekyll/build" \
       -it jekyll/jekyll:4.2.0 \
       jekyll build --source /srv/jekyll/src --destination /srv/jekyll/build


docker build . -f server/Dockerfile -t techtrickery-net:latest


