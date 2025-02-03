#!/bin/bash

# Update package lists
echo "Updating package lists..."
if ! sudo apt update -y; then
    echo "Failed to update package lists. Exiting."
    exit 1
fi

# Install NVIDIA drivers, utilities, and CUDA toolkit
echo "Installing NVIDIA drivers, utilities, and CUDA toolkit..."
if ! sudo apt install -y nvidia-driver-550-server nvidia-utils-550-server ffmpeg nvidia-cuda-toolkit; then
    echo "Failed to install NVIDIA components. Exiting."
    exit 1
fi

# Add RAM disk to /etc/fstab
RAMDISK_DIR="/mnt/ramdisk"
RAMDISK_ENTRY="tmpfs   $RAMDISK_DIR   tmpfs   size=8G   0   0"

echo "Setting up RAM disk..."
if [ ! -d "$RAMDISK_DIR" ]; then
    echo "Creating RAM disk directory at $RAMDISK_DIR..."
    sudo mkdir -p "$RAMDISK_DIR"
    echo "Directory created."
else
    echo "RAM disk directory already exists at $RAMDISK_DIR."
fi

if ! grep -Fxq "$RAMDISK_ENTRY" /etc/fstab; then
    echo "Adding RAM disk entry to /etc/fstab..."
    echo "$RAMDISK_ENTRY" | sudo tee -a /etc/fstab
    echo "RAM disk entry added."
else
    echo "RAM disk entry already exists in /etc/fstab."
fi

# Mount the RAM disk
echo "Mounting RAM disk..."
if ! sudo mount "$RAMDISK_DIR"; then
    echo "Failed to mount RAM disk. Exiting."
    exit 1
fi

# Install Jellyfin
echo "Installing Jellyfin..."
if ! curl -fsSL https://repo.jellyfin.org/install-debuntu.sh | sudo bash; then
    echo "Failed to install Jellyfin. Exiting."
    exit 1
fi

echo "Installation complete. Reboot is recommended to ensure all changes take effect."
read -p "Reboot now? (y/n): " REBOOT
if [[ "$REBOOT" =~ ^[Yy]$ ]]; then
    sudo reboot
fi
