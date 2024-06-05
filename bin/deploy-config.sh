#!/bin/bash -eu

set -o pipefail

# Portably go to the directory that this script is in
cd "$(dirname ${BASH_SOURCE[0]})"

rsync -aqzP --delete nginx.conf tech-trickery-aws:~/

ssh tech-trickery-aws <<EOF
    sudo cp ~/nginx.conf /etc/nginx/nginx.conf
    sudo nginx -t
    sudo nginx -s reload
EOF


# Is it up?
curl 107.22.129.208
