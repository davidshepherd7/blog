set -o errexit
set -o nounset

# Build html files
jekyll build

# Copy to servers
scp -r _site/* compsoc:~/public_html/
scp -r _site/* aws:~/public_html/
