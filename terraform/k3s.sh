#!/bin/bash

# Update package lists
sudo apt update

# Upgrade installed packages without user prompt
sudo apt upgrade -y

# Install k3s using the official installer script
sudo curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644" sh -

# Check the status of k3s service
sudo systemctl status k3s

