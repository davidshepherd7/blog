#!/bin/bash

set -o errexit
set -o nounset

SCRIPTDIR="$( cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd )"
cd "$SCRIPTDIR"


# Generate quotes page
cat <<EOF > quotes.md
---
layout: default
title: "Quotes"
---


$(./_quotes/my-clippings-parser.js)
EOF

# Build html files
jekyll build

# Copy to servers
scp -r _site/* compsoc:~/public_html/
scp -r _site/* aws:~/public_html/
