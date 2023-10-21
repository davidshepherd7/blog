#!/bin/bash

set -o errexit
set -o nounset

SCRIPTDIR="$( cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd )"
cd "$SCRIPTDIR"


bundle install

# Build html files
jekyll build --baseurl http://107.22.129.208/

# https://aws.amazon.com/premiumsupport/knowledge-center/user-data-replace-key-pair-ec2/

# Copy to servers
rsync -aqzP --delete ./_site/ aws:~/public_html
