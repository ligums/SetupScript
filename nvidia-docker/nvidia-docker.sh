#!/bin/bash

# Script to set up NVIDIA GPUs for Docker on Ubuntu 22.04

set -e

echo "Starting NVIDIA Docker setup..."

# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
  echo "Docker not found. Installing Docker..."
  sudo apt install -y docker.io
  sudo systemctl enable --now docker
else
  echo "Docker is already installed."
fi

# Verify Docker installation
docker --version

# Install NVIDIA Container Toolkit
echo "Setting up NVIDIA Container Toolkit..."
distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-docker-keyring.gpg
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt update
sudo apt install -y nvidia-container-toolkit

# Configure Docker to use the NVIDIA runtime
echo "Configuring Docker to use NVIDIA runtime..."
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Test NVIDIA setup with Docker
echo "Testing NVIDIA GPUs with Docker..."
docker run --rm --gpus all nvidia/cuda:12.0.1-base-ubuntu20.04 nvidia-smi

echo "NVIDIA Docker setup is complete!"
