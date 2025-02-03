#!/bin/bash

# Variables
VERSION="1.8.2"
USER="node_exporter"
BIN_PATH="/usr/local/bin/node_exporter"
SERVICE_PATH="/etc/systemd/system/node_exporter.service"

# Mettre à jour le système
echo "🔄 Mise à jour du système..."
sudo apt update -y

# Télécharger et extraire Node Exporter
echo "⬇️ Téléchargement de Node Exporter v$VERSION..."
wget -q https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz

echo "📦 Extraction..."
tar xvf node_exporter-$VERSION.linux-amd64.tar.gz > /dev/null

# Déplacer le binaire
echo "🚀 Installation de Node Exporter..."
sudo mv node_exporter-$VERSION.linux-amd64/node_exporter $BIN_PATH

# Nettoyer les fichiers inutiles
rm -rf node_exporter-$VERSION.linux-amd64 node_exporter-$VERSION.linux-amd64.tar.gz

# Créer un utilisateur dédié
echo "👤 Création de l'utilisateur $USER..."
sudo useradd --no-create-home --shell /bin/false $USER
sudo chown $USER:$USER $BIN_PATH

# Configurer le service systemd
echo "⚙️ Configuration du service systemd..."
sudo tee $SERVICE_PATH > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=$USER
ExecStart=$BIN_PATH --collector.cpu --collector.meminfo --collector.filesystem
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Recharger systemd et démarrer Node Exporter
echo "🔄 Rechargement de systemd et démarrage de Node Exporter..."
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter

# Vérification du service
echo "✅ Vérification du statut du service..."
sudo systemctl status node_exporter --no-pager

# Tester l'accès aux métriques
echo "📊 Test des métriques Node Exporter..."
curl -s http://localhost:9100/metrics | head -n 10

echo "🎉 Installation terminée ! Node Exporter tourne sur le port 9100."
