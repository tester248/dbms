#!/bin/bash

# ===============================
# Oracle XE 21c Docker Installer
# ===============================

# Exit on any error
set -e

# Step 1: Update packages
echo "Updating package lists..."
sudo apt update

# Step 2: Install Docker and dependencies
echo "Installing Docker..."
sudo apt install -y docker.io docker-compose

# Step 3: Enable Docker to start on boot
echo "Enabling Docker service..."
sudo systemctl enable --now docker

# Step 4: Add current user to the Docker group
echo "Adding user $USER to docker group..."
sudo usermod -aG docker $USER

echo "Docker installation complete."
echo "IMPORTANT: Log out and log back in, or restart the terminal for Docker permissions to take effect."
echo "After that, re-run this script with the 'run' argument to start Oracle XE container."
exit 0