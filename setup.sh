#!/bin/bash

# Setup script for Apple AirTag Detector on Raspberry Pi
# Run with: chmod +x setup.sh && sudo ./setup.sh

set -e

echo "Setting up Apple AirTag Detector on Raspberry Pi..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Update package list
echo "Updating package list..."
apt update

# Install required system packages
echo "Installing system dependencies..."
apt install -y python3 python3-pip python3-venv bluetooth bluez libbluetooth-dev

# Enable and start Bluetooth service
echo "Enabling Bluetooth service..."
systemctl enable bluetooth
systemctl start bluetooth

# Create virtual environment
echo "Setting up Python virtual environment..."
cd /home/ubuntu/dogpi
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
echo "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Make the script executable
chmod +x airtag_detector.py
chmod +x setup_homekit.py
chmod +x test_bluetooth.py

# Install systemd service
echo "Installing systemd service..."
cp airtag-detector.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable airtag-detector.service

echo "Setup complete!"
echo ""
echo "IMPORTANT: Configure HomeKit integration before starting the service!"
echo "Run: python3 setup_homekit.py"
echo ""
echo "To start the service:"
echo "  sudo systemctl start airtag-detector.service"
echo ""
echo "To check service status:"
echo "  sudo systemctl status airtag-detector.service"
echo ""
echo "To view logs:"
echo "  sudo journalctl -u airtag-detector.service -f"
echo "  or check: /home/ubuntu/dogpi/airtag_detector.log"
echo ""
echo "To stop the service:"
echo "  sudo systemctl stop airtag-detector.service"
