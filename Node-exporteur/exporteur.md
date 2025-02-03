# Node Exporter Installation Script

This script automates the installation of [Node Exporter](https://github.com/prometheus/node_exporter), a tool for exposing system metrics to Prometheus. It installs the specified version of Node Exporter, sets up a dedicated user, configures the service with systemd, and starts the service.

## Prerequisites

- **Ubuntu-based system**: This script is designed to work on an Ubuntu-based operating system.
- **sudo privileges**: You need to have sudo privileges on the machine to run this script.
- **Network connectivity**: Ensure the server can download from the internet (for downloading the Node Exporter binary).

## Script Overview

The script performs the following steps:

1. Updates the system using `apt update`.
2. Downloads the specified version of Node Exporter (default is v1.8.2).
3. Extracts the archive and moves the binary to `/usr/local/bin/node_exporter`.
4. Cleans up unnecessary files after extraction.
5. Creates a dedicated user (`node_exporter`) without home directory and shell access for security.
6. Configures a systemd service to manage the Node Exporter service.
7. Reloads systemd, starts the Node Exporter service, and enables it to start on boot.
8. Verifies the status of the service and checks the availability of metrics on `http://localhost:9100/metrics`.

## Usage

### 1. Download or Clone the Repository
Clone or download this repository to your local machine.

```bash
wget https://raw.githubusercontent.com/ligums/SetupScript/main/Node-exporteur/exporteur.sh
chmod +x exporteur.sh
./exporteur.sh
