#!/bin/bash

# Installation script for AirTag Detector pip package
# This script handles both pip installation and system setup

set -e

echo "AirTag Detector Installation Script"
echo "=================================="

# Check if running on supported system
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "❌ This package is designed for Linux systems (Raspberry Pi)"
    exit 1
fi

# Check if Python 3.8+ is available
python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
required_version="3.8"

if ! python3 -c "import sys; exit(0 if sys.version_info >= (3, 8) else 1)" 2>/dev/null; then
    echo "❌ Python 3.8 or higher is required. Found: $python_version"
    exit 1
fi

echo "✅ Python $python_version detected"

# Check for externally managed environment
check_externally_managed() {
    if python3 -c "import sys; print(sys.prefix)" 2>/dev/null | grep -q "/usr"; then
        if [ -f "/usr/lib/python*/EXTERNALLY-MANAGED" ] 2>/dev/null || python3 -m pip install --dry-run requests 2>&1 | grep -q "externally.managed"; then
            return 0  # Externally managed
        fi
    fi
    return 1  # Not externally managed
}

# Function to install pipx if not available
install_pipx() {
    if ! command -v pipx &> /dev/null; then
        echo "Installing pipx..."
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y pipx python3-full
        else
            echo "❌ pipx not available and cannot install via apt"
            return 1
        fi
    fi
    
    # Ensure pipx is in PATH
    if ! command -v pipx &> /dev/null; then
        export PATH="$HOME/.local/bin:$PATH"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
    
    pipx ensurepath
    return 0
}

# Function to create virtual environment
create_venv() {
    local venv_path="$HOME/.local/share/airtag-detector-venv"
    echo "Creating virtual environment at $venv_path..."
    
    python3 -m venv "$venv_path"
    source "$venv_path/bin/activate"
    pip install --upgrade pip
    
    echo "✅ Virtual environment created"
    echo "$venv_path"
}

# Determine installation method
if check_externally_managed; then
    echo "⚠️  Detected externally managed Python environment"
    echo ""
    echo "Installation options:"
    echo "1. Use pipx (recommended for applications)"
    echo "2. Use virtual environment"
    echo "3. Exit and install manually"
    
    while true; do
        read -p "Choose installation method (1-3): " method_choice
        case $method_choice in
            1)
                INSTALL_METHOD="pipx"
                break
                ;;
            2)
                INSTALL_METHOD="venv"
                break
                ;;
            3)
                echo "Manual installation instructions:"
                echo "1. Install pipx: sudo apt install pipx python3-full"
                echo "2. Install package: pipx install airtag-detector"
                echo "3. Run setup: sudo ~/.local/bin/airtag-setup"
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter 1-3."
                ;;
        esac
    done
else
    INSTALL_METHOD="pip"
fi

# Function to install package
install_package() {
    echo "Installing AirTag Detector package using $INSTALL_METHOD..."
    
    case $INSTALL_METHOD in
        "pipx")
            if ! install_pipx; then
                echo "❌ Failed to install pipx"
                exit 1
            fi
            
            if [[ "$1" == "--dev" ]]; then
                echo "Development installation not supported with pipx"
                echo "Use virtual environment method instead"
                exit 1
            else
                echo "Installing from PyPI with pipx..."
                pipx install airtag-detector
            fi
            ;;
            
        "venv")
            VENV_PATH=$(create_venv)
            source "$VENV_PATH/bin/activate"
            
            if [[ "$1" == "--dev" ]]; then
                echo "Installing in development mode..."
                pip install -e .
            else
                echo "Installing from PyPI..."
                pip install airtag-detector
            fi
            
            # Create wrapper scripts
            create_venv_wrappers "$VENV_PATH"
            ;;
            
        "pip")
            if [[ "$1" == "--dev" ]]; then
                echo "Installing in development mode..."
                pip3 install -e .
            else
                echo "Installing from PyPI..."
                pip3 install airtag-detector
            fi
            ;;
    esac
    
    echo "✅ Package installation completed"
}

# Function to create wrapper scripts for virtual environment
create_venv_wrappers() {
    local venv_path="$1"
    local bin_dir="$HOME/.local/bin"
    
    mkdir -p "$bin_dir"
    
    # Create wrapper scripts
    cat > "$bin_dir/airtag-detector" << EOF
#!/bin/bash
source "$venv_path/bin/activate"
exec "$venv_path/bin/airtag-detector" "\$@"
EOF

    cat > "$bin_dir/airtag-setup" << EOF
#!/bin/bash
source "$venv_path/bin/activate"
exec "$venv_path/bin/airtag-setup" "\$@"
EOF

    cat > "$bin_dir/airtag-homekit-setup" << EOF
#!/bin/bash
source "$venv_path/bin/activate"
exec "$venv_path/bin/airtag-homekit-setup" "\$@"
EOF

    cat > "$bin_dir/airtag-test" << EOF
#!/bin/bash
source "$venv_path/bin/activate"
exec "$venv_path/bin/airtag-test" "\$@"
EOF

    chmod +x "$bin_dir"/airtag-*
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    echo "✅ Command wrappers created in $bin_dir"
}

# Function to run system setup
run_system_setup() {
    echo "Running system setup..."
    
    case $INSTALL_METHOD in
        "pipx")
            ~/.local/bin/airtag-setup
            ;;
        "venv")
            airtag-setup
            ;;
        "pip")
            airtag-setup
            ;;
    esac
}

# Main installation logic
echo ""
echo "Installation options:"
echo "1. Install package only"
echo "2. Install package + system setup (requires sudo)"
echo "3. Development installation (from current directory)"
echo "4. Exit"

while true; do
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1)
            install_package
            echo ""
            echo "✅ Package installed successfully!"
            echo ""
            echo "Commands available:"
            case $INSTALL_METHOD in
                "pipx")
                    echo "- ~/.local/bin/airtag-setup (system setup)"
                    echo "- ~/.local/bin/airtag-homekit-setup (HomeKit config)"
                    echo "- ~/.local/bin/airtag-test (test Bluetooth)"
                    ;;
                *)
                    echo "- airtag-setup (system setup)"
                    echo "- airtag-homekit-setup (HomeKit config)"
                    echo "- airtag-test (test Bluetooth)"
                    ;;
            esac
            echo ""
            echo "Next steps:"
            echo "1. Run system setup: sudo airtag-setup"
            echo "2. Configure HomeKit: airtag-homekit-setup"
            echo "3. Test setup: airtag-test"
            break
            ;;
        2)
            install_package
            echo ""
            if [[ $EUID -eq 0 ]]; then
                run_system_setup
            else
                echo "System setup requires root privileges..."
                sudo airtag-setup
            fi
            echo ""
            echo "✅ Complete installation finished!"
            echo ""
            echo "Next steps:"
            echo "1. Configure HomeKit: airtag-homekit-setup"
            echo "2. Test setup: sudo airtag-test"
            echo "3. Start service: sudo systemctl start airtag-detector.service"
            break
            ;;
        3)
            if [[ ! -f "setup.py" ]] && [[ ! -f "pyproject.toml" ]]; then
                echo "❌ No setup.py or pyproject.toml found. Are you in the project directory?"
                exit 1
            fi
            install_package --dev
            echo ""
            echo "✅ Development installation completed!"
            echo ""
            echo "Next steps:"
            echo "1. Run system setup: sudo airtag-setup"
            echo "2. Configure HomeKit: airtag-homekit-setup"
            break
            ;;
        4)
            echo "Installation cancelled."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter 1-4."
            ;;
    esac
done
