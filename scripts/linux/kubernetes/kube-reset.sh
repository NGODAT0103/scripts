#!/bin/bash
kubeadm reset --force
rm $HOME/.kube/config
rm /etc/kubernetes/admin.conf
rm -r /etc/cni
# List rules.
sudo iptables -L

# Set default policies to accept.
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

# Flush and delete tables and chains.
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X

# Get all routes containing 'bird' or 'flannel'
BIRD_FLANNEL_ROUTES=$(ip route | grep -E 'bird|flannel')

# Loop through each route containing 'bird' or 'flannel' and delete it
while read -r route; do
  # Extract the full route details
  echo "Deleting route: $route"

  # Handle different types of routes: unreachable, blackhole, or normal
  if [[ "$route" =~ unreachable ]]; then
    DEST=$(echo "$route" | awk '{print $2}')
    ip route del unreachable "$DEST"
  elif [[ "$route" =~ blackhole ]]; then
    DEST=$(echo "$route" | awk '{print $2}')
    ip route del blackhole "$DEST"
  else
    DEST=$(echo "$route" | awk '{print $1}')
    ip route del "$DEST"
  fi
done <<< "$BIRD_FLANNEL_ROUTES"

# Confirm the remaining routes
echo "Remaining routes:"
ip route

