# AirTag Detector Project Structure

## Root Directory

```
├── airtag_detector/              # Main Python package
│   ├── __init__.py              # Package initialization
│   ├── detector.py              # Core detection logic
│   ├── homekit_controller.py    # HomeKit integration
│   ├── homekit_setup.py         # HomeKit setup wizard
│   ├── setup.py                 # Installation utilities
│   ├── test_bluetooth.py        # Bluetooth testing tools
│   ├── configs/                 # Configuration templates
│   │   └── config.py.template   # Configuration template
│   └── templates/               # Service and system templates
│       └── airtag-detector.service # Systemd service template
│
├── docs/                        # Documentation files
│   ├── README.md                # Main project documentation
│   ├── README_PACKAGE.md        # PyPI package documentation
│   ├── QUICKSTART.md            # Quick start guide
│   ├── INSTALLATION_EXTERNALLY_MANAGED.md # Modern Python environments
│   └── PUBLISHING_GUIDE.md      # Developer publishing guide
│
├── scripts/                     # Installation and utility scripts
│   ├── install.sh               # Smart installer
│   ├── quick_install.sh         # One-line installer
│   ├── setup.sh                 # Legacy setup script
│   └── publish.sh               # Package publishing script
│
├── build/                       # Build configuration
│   ├── pyproject.toml           # Modern Python packaging
│   ├── setup.py                 # Legacy setuptools
│   ├── MANIFEST.in              # Package manifest
│   └── requirements.txt         # Dependencies
│
└── project/                     # Project files
    ├── LICENSE                  # MIT License
    ├── .gitignore              # Git ignore rules
    └── build_env/              # Build virtual environment (local only)
```

## Generated Files (Not in Version Control)

```
├── dist/                        # Built packages (.whl, .tar.gz)
├── build/                       # Build artifacts
├── *.egg-info/                 # Package metadata
├── __pycache__/                # Python bytecode
├── .env                        # Environment variables
├── config.py                   # User configuration
├── *.log                       # Log files
└── *.json                      # Runtime data files
```

## Key Files

- **`airtag_detector/detector.py`** - Main detection engine
- **`airtag_detector/homekit_controller.py`** - HomeKit device control
- **`install.sh`** - Handles all installation scenarios
- **`publish.sh`** - PyPI publishing automation
- **`pyproject.toml`** - Modern packaging configuration
- **`README_PACKAGE.md`** - Documentation shown on PyPI

## Installation Entry Points

After installation, users get these commands:

- `airtag-detector` - Main detection service
- `airtag-setup` - Initial setup wizard
- `airtag-homekit-setup` - HomeKit configuration
- `airtag-test` - Bluetooth testing utility
