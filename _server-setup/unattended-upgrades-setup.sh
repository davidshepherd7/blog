#!/bin/bash -eu

set -o pipefail

# Portably go to the directory that this script is in
cd "$(dirname ${BASH_SOURCE[0]})"

rsync -aqzP --delete unattended-upgrades-conf tech-trickery-aws:~/


ssh tech-trickery-aws <<EOF
    sudo cp ~/unattended-upgrades-conf /etc/apt/apt.conf.d/50unattended-upgrades
    sudo systemctl restart unattended-upgrades.service
EOF
