#!/bin/bash
docker rm -f nas

docker build -f Dockerfile -t nas2 .
docker run -d \
  --privileged \
  --device=/dev/sda1 \
  --name nas \
  --restart unless-stopped \
  -p 22001:22 \
  -e SSH_KEY="$(cat ssh_key)" \
  -e MOUNT_DEVICE=sda1 \
  -e ROOT_DIR=/mnt/sda1/share \
  nas2
