#!/bin/bash

# Quick installer for AirTag Detector that handles externally managed environments
# Usage: curl -sSL https://raw.githubusercontent.com/nranderson/dogpi/main/quick_install.sh | bash

set -e

echo "🔍 AirTag Detector Quick Installer"
echo "================================="

# Function to install using pipx
install_with_pipx() {
    echo "Installing with pipx..."
    
    # Install pipx if not available
    if ! command -v pipx &> /dev/null; then
        echo "Installing pipx..."
        sudo apt update
        sudo apt install -y pipx python3-full
        pipx ensurepath
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    # Install the package
    pipx install airtag-detector
    
    echo "✅ Installation completed with pipx!"
    echo ""
    echo "Next steps:"
    echo "1. Run system setup: sudo ~/.local/bin/airtag-setup"
    echo "2. Configure HomeKit: ~/.local/bin/airtag-homekit-setup"
    echo "3. Test setup: sudo ~/.local/bin/airtag-test"
}

# Function to install with virtual environment
install_with_venv() {
    echo "Installing with virtual environment..."
    
    VENV_PATH="$HOME/.local/share/airtag-detector-venv"
    
    # Create virtual environment
    python3 -m venv "$VENV_PATH"
    source "$VENV_PATH/bin/activate"
    pip install --upgrade pip
    pip install airtag-detector
    
    # Create wrapper scripts
    mkdir -p "$HOME/.local/bin"
    
    cat > "$HOME/.local/bin/airtag-detector" << EOF
#!/bin/bash
source "$VENV_PATH/bin/activate"
exec "$VENV_PATH/bin/airtag-detector" "\$@"
EOF

    cat > "$HOME/.local/bin/airtag-setup" << EOF
#!/bin/bash
source "$VENV_PATH/bin/activate"
exec "$VENV_PATH/bin/airtag-setup" "\$@"
EOF

    cat > "$HOME/.local/bin/airtag-homekit-setup" << EOF
#!/bin/bash
source "$VENV_PATH/bin/activate"
exec "$VENV_PATH/bin/airtag-homekit-setup" "\$@"
EOF

    cat > "$HOME/.local/bin/airtag-test" << EOF
#!/bin/bash
source "$VENV_PATH/bin/activate"
exec "$VENV_PATH/bin/airtag-test" "\$@"
EOF

    chmod +x "$HOME/.local/bin"/airtag-*
    
    # Add to PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    echo "✅ Installation completed with virtual environment!"
    echo ""
    echo "Next steps:"
    echo "1. Run system setup: sudo airtag-setup"
    echo "2. Configure HomeKit: airtag-homekit-setup" 
    echo "3. Test setup: sudo airtag-test"
}

# Check if externally managed
if python3 -c "import sys; import os; exit(0 if os.path.exists('/usr/lib/python*/EXTERNALLY-MANAGED') else 1)" 2>/dev/null; then
    echo "⚠️  Detected externally managed Python environment"
    echo ""
    echo "Choose installation method:"
    echo "1. pipx (recommended)"
    echo "2. Virtual environment"
    
    read -p "Enter choice (1-2): " choice
    
    case $choice in
        1)
            install_with_pipx
            ;;
        2)
            install_with_venv
            ;;
        *)
            echo "Invalid choice, using pipx..."
            install_with_pipx
            ;;
    esac
else
    echo "Installing with pip..."
    pip3 install airtag-detector
    echo "✅ Installation completed!"
    echo ""
    echo "Next steps:"
    echo "1. Run system setup: sudo airtag-setup"
    echo "2. Configure HomeKit: airtag-homekit-setup"
    echo "3. Test setup: sudo airtag-test"
fi

echo ""
echo "🎉 Installation complete!"
echo "Run 'airtag-setup --help' for more information."
