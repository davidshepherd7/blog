set -o errexit
set -o nounset

# Build html files
jekyll build

# Copy to server
scp -r _site/* aws:~/public_html/
