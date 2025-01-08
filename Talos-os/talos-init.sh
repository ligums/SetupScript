#!/bin/bash

# Set the control plane IP and configuration directory
CONTROL_PLANE_IP="10.0.4.101"
TALOSDIR="_pve-tf"
TALOSCONFIG="${TALOSDIR}/talosconfig"
CLUSTER_NAME="talos-proxmox-cluster"

# List of worker node IPs (can be modified or passed as arguments)
WORKER_NODES=("10.0.4.102" "10.0.4.103")

# Ensure the _pve-tf directory exists
mkdir -p "$TALOSDIR"

# Generate Talos configuration for the cluster
echo "Generating Talos configuration..."
if ! talosctl gen config $CLUSTER_NAME https://$CONTROL_PLANE_IP:6443 --output-dir "$TALOSDIR"; then
    echo "Failed to generate Talos configuration" >&2
    exit 1
fi

# Apply the generated configuration to the control plane node
echo "Applying Talos configuration to the control plane node..."
if ! talosctl apply-config --insecure --nodes $CONTROL_PLANE_IP --file "$TALOSDIR/controlplane.yaml" -e $CONTROL_PLANE_IP; then
    echo "Failed to apply Talos configuration" >&2
    exit 1
fi

echo 30s sleep
sleep 30

# Set the Talos endpoint and node configuration
echo "Setting Talos endpoint and node configuration..."
cp "$TALOSCONFIG" ./.talos/config
talosctl config endpoint $CONTROL_PLANE_IP
talosctl config node $CONTROL_PLANE_IP

# Bootstrap the Talos cluster
echo "Bootstrapping the Talos cluster..."
if ! talosctl bootstrap; then
    echo "Failed to bootstrap the Talos cluster" >&2
    exit 1
fi

# Add worker nodes if specified
if [ ${#WORKER_NODES[@]} -gt 0 ]; then
    echo "Adding worker nodes..."
    for WORKER_IP in "${WORKER_NODES[@]}"; do
        echo "Applying configuration to worker node: $WORKER_IP"
        if ! talosctl apply-config --insecure --nodes $WORKER_IP --file "$TALOSDIR/worker.yaml" -e $CONTROL_PLANE_IP; then
            echo "Failed to apply Talos configuration to worker node: $WORKER_IP" >&2
            exit 1
        fi
    done
fi

# Generate kubeconfig for Kubernetes cluster access
echo "Generating Kubernetes kubeconfig..."
if ! talosctl kubeconfig . --endpoints $CONTROL_PLANE_IP --nodes $CONTROL_PLANE_IP; then
    echo "Failed to generate Kubernetes kubeconfig" >&2
    exit 1
fi

# Move kubeconfig to the default Kubernetes configuration location
echo "Moving kubeconfig to ~/.kube/config..."
mkdir -p ~/.kube
mv kubeconfig ~/.kube/config

echo "Talos control plane, worker nodes, and Kubernetes access setup completed successfully."
