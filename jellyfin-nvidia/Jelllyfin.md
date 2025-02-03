# Automated Setup Script for NVIDIA Drivers, RAM Disk, and Jellyfin

This script automates the installation and configuration of NVIDIA drivers, CUDA toolkit, a RAM disk, and the Jellyfin media server on a Linux system (Debian/Ubuntu-based distributions). It ensures compatibility with required components and minimizes manual steps.

---

## Features
1. **NVIDIA Drivers and CUDA Toolkit Installation**:
   - Installs NVIDIA drivers (`nvidia-driver-550-server`).
   - Sets up `nvidia-utils` for GPU utility support.
   - Installs `nvidia-cuda-toolkit` for CUDA-enabled applications.

2. **RAM Disk Configuration**:
   - Creates a directory at `/mnt/ramdisk` (if it doesn't already exist).
   - Adds a RAM disk entry to `/etc/fstab` with 8GB of allocated space.
   - Mounts the RAM disk immediately for use.

3. **Jellyfin Media Server Installation**:
   - Automatically installs Jellyfin using the official repository setup script.

4. **Error Handling and Validation**:
   - Verifies system compatibility and resource availability.
   - Provides meaningful feedback during each step.

---

## Prerequisites
- A Debian/Ubuntu-based Linux distribution.
- Sudo privileges for installation and configuration tasks.
- Sufficient system RAM (at least 16GB is recommended to allocate an 8GB RAM disk).

---

## Usage

### 1. Download the Script

Download this repository to your local machine.

```bash
wget https://raw.githubusercontent.com/ligums/SetupScript/main/jellyfin-nvidia/jellyfin.sh
chmod +x jellyfin.sh
./jellyfin.sh
