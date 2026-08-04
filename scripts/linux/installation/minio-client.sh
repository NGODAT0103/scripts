#!/bin/bash
curl https://dl.min.io/client/mc/release/linux-arm64/mc \
  --create-dirs \
  -o ~/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

mc --help
