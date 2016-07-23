set -o errexit
set -o nounset

# Build html files
jekyll build

# Copy to servers
scp -r _site/* compsoc:~/public_html/
scp -r _site/* ec2-user@:~/public_html/
