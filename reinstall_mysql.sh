#!/bin/bash
# Script to completely remove MySQL and reinstall on Ubuntu, then set root password

set -e  # Exit immediately if a command exits with a non-zero status

MYSQL_ROOT_PASSWORD="Mmcoe123!"   # <-- Change this to your desired root password

echo "Purging existing MySQL installation..."
sudo apt purge -y mysql-server mysql-client mysql-common

echo "Removing unnecessary packages..."
sudo apt autoremove -y
sudo apt autoclean -y

echo "Removing MySQL data directory..."
sudo rm -rf /var/lib/mysql

echo "Updating package index..."
sudo apt update -y

echo "Installing MySQL server..."
sudo apt install -y mysql-server

echo "Securing MySQL root user with password..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

echo "Root password set successfully!"
echo "You can now login using: mysql -u root -p"