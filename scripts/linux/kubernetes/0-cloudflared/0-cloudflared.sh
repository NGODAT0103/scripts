#!/bin/bash
set -e
set -x

CF_TUNNEL_VERSION="2024.11.0"
read -p "Enter your Cloudflare Tunnel version [default: $CF_TUNNEL_VERSION]: " CF_TUNNEL_VERSION
CF_TUNNEL_VERSION=${CF_TUNNEL_VERSION:-2024.11.0}
if [ -z "$CF_TUNNEL_TOKEN" ]; then
  read -p "Enter your Cloudflare Tunnel token: " CF_TUNNEL_TOKEN
fi
sed "s/\${CF_TUNNEL_VERSION}/${CF_TUNNEL_VERSION}/g" cloudflared.yaml | sed "s/\${CF_TUNNEL_TOKEN}/$CF_TUNNEL_TOKEN/g" | kubectl apply -f -
