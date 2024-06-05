#!/bin/bash -eu

set -o pipefail

# Portably go to the directory that this script is in
cd "$(dirname ${BASH_SOURCE[0]})"

./build.sh

# Login to docker aws
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/w9r4b4d3

# Push the container
docker tag techtrickery-net:latest public.ecr.aws/w9r4b4d3/techtrickery-net:latest
docker push public.ecr.aws/w9r4b4d3/techtrickery-net:latest

# TODO probably have to ssh to the VM and pull? IDK


# Commands to stand up a new VM:
#
# sudo apt update
# sudo apt install podman
# sudo podman pull public.ecr.aws/w9r4b4d3/techtrickery-net:latest
# sudo podman run -d --name techtrickery-net -p 80:80 techtrickery-net
#
# sudo podman generate systemd --new --name --files techtrickery-net
# sudo mv /home/admin/container-techtrickery-net.service /etc/systemd/system/
# sudo systemctl enable container-techtrickery-net.service
# sudo systemctl start container-techtrickery-net.service

