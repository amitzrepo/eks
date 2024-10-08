
# Kubernetes v1.31 Installation Guide

This guide walks through the process of installing Kubernetes v1.31 using the apt package manager on Debian/Ubuntu systems.

## Prerequisites

Ensure that you have a compatible version of Debian or Ubuntu installed. These instructions are written for Kubernetes v1.31. For other versions, you may need to adjust accordingly.

### Step 1: Disable swap

```yaml
sudo swapoff -a
```

### Step 2: Install Docker & start Docker

```yaml
sudo apt update && sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
```

### Step 3: Update the apt package index and install required packages

```yaml
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
```

### Step 4: Download the Kubernetes apt repository signing key

If the `/etc/apt/keyrings` directory does not exist, create it before proceeding.

```yaml
# Create the directory if it doesn't exist
sudo mkdir -p -m 755 /etc/apt/keyrings

# Download the signing key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

> **Note:** In releases older than Debian 12 and Ubuntu 22.04, the `/etc/apt/keyrings` directory is not present by default, and should be created manually.

### Step 5: Add the Kubernetes apt repository

This command adds the repository for Kubernetes v1.31. For other versions, update the URL accordingly.

```yaml
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

### Step 6: Update apt and install Kubernetes components

```yaml
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

### Step 7 (Optional): Enable and start kubelet service

```yaml
sudo systemctl enable --now kubelet
```

### Step 8: Initialize kubeadm (Only for master node)

```yaml
sudo kubeadm init
```

### Step 9: Deploy network

```yaml
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

Your system is now ready to use Kubernetes v1.31.

### CHeck with the command

```yaml
kubectl get nods
```
