#!/bin/bash -eu

set -o pipefail

# Portably go to the directory that this script is in
cd "$(dirname ${BASH_SOURCE[0]})"

ssh -t tech-trickery-aws <<EOF
    # They say to install the snap version so :shrug:
    sudo apt-get remove certbot
    sudo snap install --classic certbot 
    sudo ln -s /snap/bin/certbot /usr/bin/certbot

    # Interactive, enter some details
    sudo certbot certonly --nginx

     
    sudo certbot renew --dry-run
EOF
