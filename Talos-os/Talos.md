# Talos Kubernetes Cluster Setup on Proxmox

This script automates the setup of a Talos Kubernetes cluster on a Proxmox environment. 

## Prerequisites

- **Talosctl**: Install `talosctl` on your local machine before running the script. Refer to the [Talos documentation](https://talos.dev/docs/) for installation instructions.
- The virtual machines must already be configured to run Talos.
- Ensure proper network connectivity between the control plane and worker nodes.
- Update the IP addresses and cluster name in the script as needed for your setup.

## Script Overview

The script performs the following steps:

1. Defines the control plane IP, configuration directory, and worker node IPs.
2. Ensures the configuration directory exists.
3. Generates Talos configurations for the cluster.
4. Applies the configuration to the control plane node.
5. Sets the Talos endpoint and node configuration.
6. Bootstraps the Talos cluster.
7. Optionally applies configurations to the specified worker nodes.

## Usage

### 1. Download the Script

Download this repository to your local machine.

```bash
wget https://raw.githubusercontent.com/ligums/SetupScript/main/Talos/talos-init.sh
chmod +x talos-init.sh
./talos-init.sh