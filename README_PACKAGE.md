# AirTag Detector

[![PyPI version](https://badge.fury.io/py/airtag-detector.svg)](https://badge.fury.io/py/airtag-detector)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Python package for detecting Apple AirTags on Raspberry Pi with HomeKit integration. Automatically controls smart plugs when AirTags are detected within approximately 3 feet.

## 🚀 Quick Start

### Installation

**Note**: If you get an "externally managed environment" error, see the [special instructions below](#externally-managed-environments).

```bash
# Install from PyPI
pip install airtag-detector

# Or install with HomeKit support
pip install airtag-detector[homekit]
```

### Externally Managed Environments

If you see "This environment is externally managed", use one of these methods:

#### Option 1: pipx (Recommended)

```bash
# Install pipx
sudo apt install pipx python3-full

# Install the package
pipx install airtag-detector

# Commands will be in ~/.local/bin/
sudo ~/.local/bin/airtag-setup
```

#### Option 2: Quick Installer

```bash
# Use our automated installer
curl -sSL <repository-url>/quick_install.sh | bash
```

#### Option 3: Virtual Environment

```bash
# Create virtual environment
python3 -m venv ~/.local/share/airtag-detector-venv
source ~/.local/share/airtag-detector-venv/bin/activate

# Install package
pip install airtag-detector

# Use full paths to commands
sudo ~/.local/share/airtag-detector-venv/bin/airtag-setup
```

### System Setup

```bash
# Run system setup (installs dependencies and systemd service)
sudo airtag-setup

# Configure HomeKit integration
airtag-homekit-setup

# Test your setup
sudo airtag-test

# Start the detector
sudo systemctl start airtag-detector.service
```

## 📋 Features

- **Bluetooth LE Scanning**: Continuously scans for Apple AirTags
- **Proximity Detection**: RSSI-based detection within ~3 feet
- **HomeKit Integration**: Automatic smart plug control
- **Home Assistant Support**: Recommended integration method
- **Systemd Service**: Runs as background service with auto-restart
- **Comprehensive Logging**: File and console logging with rotation
- **Configurable**: Adjustable detection range and delays

## 🔧 Requirements

- **Hardware**: Raspberry Pi with built-in Bluetooth (Pi 3, Pi 4, Pi Zero W, etc.)
- **OS**: Raspberry Pi OS (Raspbian) or similar Linux distribution
- **Python**: 3.8 or higher
- **Smart Device**: HomeKit-enabled smart plug or Home Assistant setup
- **Access**: Root/sudo access for Bluetooth operations

## 📦 Package Structure

```
airtag-detector/
├── airtag_detector/
│   ├── __init__.py           # Package initialization
│   ├── detector.py           # Main detection logic
│   ├── homekit_controller.py # HomeKit integration
│   ├── setup.py             # System setup utilities
│   ├── homekit_setup.py     # HomeKit configuration
│   ├── test_bluetooth.py    # Bluetooth testing
│   ├── templates/           # Service files
│   └── configs/             # Configuration templates
├── setup.py                 # Package setup
├── pyproject.toml          # Modern packaging config
└── README.md               # This file
```

## 🛠️ Installation Methods

### Method 1: Simple Installation

```bash
pip install airtag-detector
sudo airtag-setup
```

### Method 2: With HomeKit Support

```bash
pip install airtag-detector[homekit]
sudo airtag-setup
airtag-homekit-setup
```

### Method 3: Development Installation

```bash
git clone https://github.com/nranderson/dogpi.git
cd airtag-detector
pip install -e .
sudo airtag-setup
```

## ⚙️ Configuration

The package creates configuration files at `~/.config/airtag-detector/config.py`:

```python
# Home Assistant Integration (recommended)
HOME_ASSISTANT_URL = "http://192.168.1.50:8123"
HOME_ASSISTANT_TOKEN = "your_long_lived_access_token"
HOME_ASSISTANT_ENTITY_ID = "switch.smart_plug"

# Detection Settings
AUTO_TURN_ON_DELAY = 30  # Seconds to wait before turning plug back on
PROXIMITY_RSSI_THRESHOLD = -70  # RSSI threshold for ~3 feet
DEBUG_HOMEKIT = True
```

## 📱 Console Commands

After installation, these commands are available:

- `airtag-detector` - Run the detector (usually via systemd)
- `airtag-setup` - System setup and installation
- `airtag-homekit-setup` - Configure HomeKit integration
- `airtag-test` - Test Bluetooth functionality

## 🏠 HomeKit Setup

### Option 1: Home Assistant (Recommended)

1. Get a long-lived access token from Home Assistant
2. Run `airtag-homekit-setup` and follow the prompts
3. Test the configuration

### Option 2: Direct HomeKit

Direct HomeKit support requires additional setup and pairing with HomeKit devices.

## 🔍 How It Works

1. **Continuous Scanning**: Uses Bluetooth LE to scan for devices
2. **Apple Device Detection**: Identifies potential AirTags using:
   - Apple company identifier (0x004C)
   - Relevant service UUIDs
   - Device name patterns
3. **Proximity Estimation**: Uses RSSI values to estimate distance
4. **Smart Plug Control**:
   - Turns OFF when AirTag detected within range
   - Turns ON after configurable delay when no AirTags detected

## 📊 Expected Behavior

### When AirTag Detected:

```
2025-06-21 10:30:15 - INFO - NEW AIRTAG DETECTED: Unknown (AA:BB:CC:DD:EE:FF) RSSI: -65 dBm
2025-06-21 10:30:15 - INFO - 🔌 Smart plug turned OFF (AirTag detected)
```

### When AirTag Leaves Range:

```
2025-06-21 10:31:45 - INFO - No AirTags detected for 30 seconds - turning plug back on
2025-06-21 10:31:45 - INFO - 🔌 Smart plug turned ON (AirTag no longer detected)
```

## 🎛️ Service Management

```bash
# Start the service
sudo systemctl start airtag-detector.service

# Stop the service
sudo systemctl stop airtag-detector.service

# Check status
sudo systemctl status airtag-detector.service

# View logs
sudo journalctl -u airtag-detector.service -f

# Enable auto-start on boot
sudo systemctl enable airtag-detector.service
```

## 🔧 Troubleshooting

### Common Issues

1. **Permission Denied**: Run with `sudo` for Bluetooth access
2. **Bluetooth Not Working**:
   ```bash
   sudo systemctl start bluetooth
   sudo hciconfig hci0 up
   ```
3. **HomeKit Not Responding**: Run `airtag-homekit-setup` to test configuration
4. **No Devices Detected**: Ensure AirTags are nearby and active

### Debug Mode

Enable debug logging by editing the configuration file or running:

```bash
airtag-detector --debug
```

## 🔒 Privacy and Legal

- Use only for detecting AirTags on your own property
- Respect local privacy laws and regulations
- This tool is for security and educational purposes
- AirTags have built-in privacy features that may limit detection

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Bleak](https://github.com/hbldh/bleak) for Bluetooth LE support
- [aiohomekit](https://github.com/Jc2k/aiohomekit) for HomeKit integration
- The Raspberry Pi Foundation for excellent hardware
- Home Assistant community for integration support

## 📞 Support

- 🐛 [Bug Reports](https://github.com/nranderson/dogpi/issues)
- 💡 [Feature Requests](https://github.com/nranderson/dogpi/issues)
- 📖 [Documentation](https://github.com/nranderson/dogpi/blob/main/README.md)

---

**⚠️ Important**: This detector may not catch all AirTags due to Apple's privacy features and anti-tracking measures. Use as part of a comprehensive security strategy.
