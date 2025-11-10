 #!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Checking for existing MongoDB installation..."

if dpkg -l | grep -q mongodb-org; then
    echo "Existing MongoDB installation found. Removing..."
    sudo systemctl stop mongod || true
    sudo apt purge -y mongodb-org*
    sudo apt autoremove -y
    sudo rm -rf /var/lib/mongodb
    sudo rm -rf /var/log/mongodb
    echo "Existing MongoDB removed."
else
    echo "No existing MongoDB installation found."
fi

echo "Adding MongoDB GPG key..."
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

echo "Adding MongoDB repository..."
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | \
    sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

echo "Updating package lists..."
sudo apt update

echo "Installing MongoDB..."
sudo apt install -y mongodb-org

echo "Starting MongoDB service..."
sudo systemctl start mongod

echo "Checking MongoDB service status..."
sudo systemctl status mongod

echo "Enabling MongoDB to start on boot..."
sudo systemctl enable mongod

echo "MongoDB installation and setup completed successfully."
