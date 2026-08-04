#!/bin/bash

# Disable swap
echo "Disabling swap..."
swapoff -a

# Comment out the swap entry in /etc/fstab
echo "Removing swap entry from /etc/fstab..."
sed -i '/ swap /s/^/#/' /etc/fstab

# Install required packages
echo "Installing required packages..."
apt update
apt install -y apt-transport-https ca-certificates curl gnupg lsb-release socat net-tools

# Add Kubernetes GPG key
echo "Adding Kubernetes GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes repository
echo "Adding Kubernetes repository..."
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes components
echo "Installing Kubernetes components..."
apt update
apt install -y kubelet kubeadm kubectl kubernetes-cni containerd net-tools

# Create containerd configuration directory
echo "Creating containerd configuration directory..."
mkdir -p /etc/containerd

# Generate default containerd configuration
echo "Generating containerd configuration..."
rm -f /etc/containerd/config.toml
containerd config default > /etc/containerd/config.toml

# Configure containerd to use systemd as the cgroup driver
echo "Configuring containerd to use systemd as the cgroup driver..."
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart containerd service
echo "Restarting containerd service..."
systemctl restart containerd
systemctl enable containerd

# Configure network settings
echo "Configuring network settings..."

# Enable IP forwarding
echo "Enabling IP forwarding..."
sysctl -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf

# Load bridge and br_netfilter modules
echo "Loading bridge and br_netfilter modules..."
modprobe bridge
modprobe br_netfilter

# Ensure net.bridge.bridge-nf-call-iptables is set in sysctl.conf
echo 'net.bridge.bridge-nf-call-iptables = 1' >> /etc/sysctl.conf

# Apply sysctl settings
echo "Applying sysctl settings..."
sysctl -p /etc/sysctl.conf

# Set node IP address in /etc/default/kubelet
echo "Setting node IP address..."
sed -i "s/^KUBELET_EXTRA_ARGS=.*/KUBELET_EXTRA_ARGS=--node-ip=$(hostname -I | awk '{print $1}')/" /etc/default/kubelet

# Restart kubelet to apply changes
echo "Restarting kubelet..."
systemctl restart kubelet
ystemctl stop apparmor
systemctl disable apparmor
systemctl restart containerd.service
echo "All tasks completed successfully!"
