# Installation Guide for Externally Managed Python Environments

If you get the "externally managed environment" error, here are your options:

## Option 1: Use pipx (Recommended)

```bash
# Install pipx and python3-full
sudo apt update
sudo apt install -y pipx python3-full

# Install the package
pipx install airtag-detector

# Add pipx bin directory to PATH (if not already done)
pipx ensurepath

# Run system setup
sudo ~/.local/bin/airtag-setup

# Configure HomeKit
~/.local/bin/airtag-homekit-setup

# Test setup
sudo ~/.local/bin/airtag-test

# Start the service
sudo systemctl start airtag-detector.service
```

## Option 2: Virtual Environment

```bash
# Create a virtual environment
python3 -m venv ~/.local/share/airtag-detector-venv

# Activate it
source ~/.local/share/airtag-detector-venv/bin/activate

# Install the package
pip install airtag-detector

# Create wrapper scripts (optional)
mkdir -p ~/.local/bin

cat > ~/.local/bin/airtag-detector << 'EOF'
#!/bin/bash
source ~/.local/share/airtag-detector-venv/bin/activate
exec ~/.local/share/airtag-detector-venv/bin/airtag-detector "$@"
EOF

cat > ~/.local/bin/airtag-setup << 'EOF'
#!/bin/bash
source ~/.local/share/airtag-detector-venv/bin/activate
exec ~/.local/share/airtag-detector-venv/bin/airtag-setup "$@"
EOF

chmod +x ~/.local/bin/airtag-*

# Add to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"

# Run setup
sudo airtag-setup
```

## Option 3: Development Installation

```bash
# Clone the repository
git clone <repository-url>
cd airtag-detector

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install in development mode
pip install -e .

# Run setup
sudo venv/bin/airtag-setup
```

## Option 4: Use the Automated Installer

```bash
# Run the automated installer which handles externally managed environments
./install.sh
```

## Why This Happens

Modern Python installations (Python 3.11+) are "externally managed" to prevent conflicts between system packages and user-installed packages. This is a safety feature to protect your system's Python environment.

## Recommended Approach

**pipx** is the recommended approach for installing Python applications like this one, as it:

- Isolates each application in its own virtual environment
- Makes commands available system-wide
- Handles all the complexity for you
- Is the official recommendation for installing Python applications
