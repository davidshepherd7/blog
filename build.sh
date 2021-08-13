#!/bin/bash

set -o errexit
set -o nounset

SCRIPTDIR="$( cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd )"
cd "$SCRIPTDIR"


# Generate quotes page
quote_file=($HOME/Dropbox/ebooks/Kindle/My\ Clippings*/*.txt)
cat <<EOF > quotes.md
---
layout: default
title: "Quotes"
---


$(./_quotes/my-clippings-parser.js "${quote_file[@]}")

$(./_quotes/my-clippings-parser.js "../manual_quotes.txt")
EOF

bundle install

# Build html files
jekyll build

# https://aws.amazon.com/premiumsupport/knowledge-center/user-data-replace-key-pair-ec2/

# Copy to servers
rsync -aqzP --delete ./_site/ aws:~/public_html
