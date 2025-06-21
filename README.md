# Apple AirTag Detector for Raspberry Pi with HomeKit Integration

[![PyPI version](https://badge.fury.io/py/airtag-detector.svg)](https://badge.fury.io/py/airtag-detector)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Python package for detecting Apple AirTags on Raspberry Pi with HomeKit integration. Automatically controls smart plugs when AirTags are detected within approximately 3 feet.

## 🚀 Quick Installation

```bash
# Using pipx (recommended)
pipx install airtag-detector

# Or using pip
pip install airtag-detector
```

## 📖 Documentation

- **[Quick Start Guide](QUICKSTART.md)** - Get up and running in minutes
- **[Installation Guide](INSTALLATION_EXTERNALLY_MANAGED.md)** - Handle modern Python environments
- **[Publishing Guide](PUBLISHING_GUIDE.md)** - For developers
- **[Package Documentation](README_PACKAGE.md)** - Complete package reference

## 🏗️ Development

This repository contains the source code for the `airtag-detector` PyPI package.

### Project Structure

```
airtag_detector/          # Main package
├── detector.py           # Core detection logic
├── homekit_controller.py # HomeKit integration
├── homekit_setup.py     # Setup wizard
├── setup.py             # Installation utilities
├── test_bluetooth.py    # Bluetooth testing
├── templates/           # Service templates
└── configs/             # Configuration templates

docs/                    # Documentation
install.sh              # Smart installer script
quick_install.sh        # One-line installer
publish.sh              # Publishing script
```

### Building and Publishing

```bash
# Clean build
./publish.sh testpypi   # Test on TestPyPI first
./publish.sh pypi       # Publish to production PyPI
```

- Logging to both file and console
- Systemd service for automatic startup
- Graceful shutdown handling
- Automatic cleanup of devices that leave range
- Configurable delay before turning plug back on

## Requirements

- Raspberry Pi with built-in Bluetooth (Pi 3, Pi 4, Pi Zero W, etc.)
- Raspberry Pi OS (Raspbian)
- Root access for Bluetooth operations
- **HomeKit-enabled smart plug** or Home Assistant setup
- Home Assistant with the smart plug integrated (recommended)

## Installation

1. Clone or download this repository to your Raspberry Pi
2. Make the setup script executable and run it:

   ```bash
   chmod +x setup.sh
   sudo ./setup.sh
   ```

3. **Configure HomeKit Integration**:

   ```bash
   python3 setup_homekit.py
   ```

## Manual Installation

If you prefer to install manually:

1. Install system dependencies:

   ```bash
   sudo apt update
   sudo apt install python3 python3-pip bluetooth bluez libbluetooth-dev
   ```

2. Install Python dependencies:

   ```bash
   pip3 install -r requirements.txt
   ```

3. Enable Bluetooth service:
   ```bash
   sudo systemctl enable bluetooth
   sudo systemctl start bluetooth
   ```

## Usage

### Running as a Service (Recommended)

Start the service:

```bash
sudo systemctl start airtag-detector.service
```

Check service status:

```bash
sudo systemctl status airtag-detector.service
```

View logs in real-time:

```bash
sudo journalctl -u airtag-detector.service -f
```

Stop the service:

```bash
sudo systemctl stop airtag-detector.service
```

### Running Manually

```bash
sudo python3 airtag_detector.py
```

Press Ctrl+C to stop.

## How It Works

The detector works by:

1. **BLE Scanning**: Continuously scans for Bluetooth Low Energy devices
2. **Apple Device Identification**: Looks for devices with Apple's company identifier (0x004C) or relevant service UUIDs
3. **Proximity Detection**: Uses RSSI (Received Signal Strength Indicator) to estimate distance
4. **Logging**: Records detections with timestamps and device information

### Detection Criteria

A device is considered a potential AirTag if it:

- Has Apple's company identifier in manufacturer data (0x004C)
- Advertises relevant service UUIDs (FD44, FEAA)
- Has a name containing keywords like "airtag", "findmy", or "apple"

### Proximity Estimation

- RSSI threshold: -70 dBm (approximately 3 feet)
- Higher RSSI values indicate closer proximity
- You may need to adjust the threshold based on your environment

## Configuration

You can modify the following parameters in `airtag_detector.py`:

- `PROXIMITY_RSSI_THRESHOLD`: RSSI threshold for proximity detection (default: -70 dBm)
- `scan_interval`: Time between scans (default: 2.0 seconds)
- Log level and file paths

## Logs

Logs are written to:

- Console output
- `/home/ubuntu/dogpi/airtag_detector.log`
- System journal (viewable with `journalctl`)

## Troubleshooting

### Permission Issues

- Run with `sudo` for Bluetooth access
- Ensure the user is in the `bluetooth` group

### Bluetooth Not Working

```bash
sudo systemctl status bluetooth
sudo hciconfig hci0 up
```

### No Devices Detected

- Ensure AirTags are nearby and active
- Check if Bluetooth is enabled and working
- Verify RSSI threshold is appropriate for your environment
- Some AirTags may not be easily detectable when in "silent" mode

### Service Not Starting

```bash
sudo systemctl status airtag-detector.service
sudo journalctl -u airtag-detector.service
```

## Limitations

- AirTags use privacy features that may limit detectability
- Detection range is approximate and depends on environmental factors
- Some AirTags may enter sleep mode or use anti-tracking features
- False positives may occur with other Apple devices

## Privacy and Legal Considerations

- This tool is for educational and security purposes
- Respect privacy laws in your jurisdiction
- Only use to detect AirTags on your own property
- Consider the privacy implications of tracking devices

## Contributing

Feel free to submit issues and pull requests to improve the detector.

## License

This project is licensed under the terms specified in the LICENSE file.
