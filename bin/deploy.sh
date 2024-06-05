#!/bin/bash -eu

set -o pipefail

# Portably go to the directory that this script is in
cd "$(dirname ${BASH_SOURCE[0]})"

# https://aws.amazon.com/premiumsupport/knowledge-center/user-data-replace-key-pair-ec2/

# # Copy to servers
# rsync --archive --compress --delete -i ./_site/ tech-trickery-aws:/var/www/html \
    #       --rsync-path="sudo rsync" \
    #       -g --groupmap '*:www-data' \
    #       -u --usermap '*:www-data'

# TODO
