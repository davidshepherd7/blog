set -o errexit
set -o nounset

# Build html files
jekyll

# Copy to server
scp -r _site/* compsoc:~/public_html/
