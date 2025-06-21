# PyPI Publishing Guide for AirTag Detector

## Package Build Status ✅

Your package has been successfully built and is ready for publishing!

**Generated Files:**

- `dist/airtag_detector-1.0.0-py3-none-any.whl` (Universal wheel)
- `dist/airtag_detector-1.0.0.tar.gz` (Source distribution)

**Build Status:** ✅ PASSED all checks with `twine check`

## Publishing Options

### Option 1: Test on TestPyPI First (Recommended)

TestPyPI is a separate instance of PyPI for testing packages.

1. **Register on TestPyPI** (if not already done):

   - Go to https://test.pypi.org/account/register/
   - Create an account and verify your email

2. **Upload to TestPyPI:**

   ```bash
   cd /home/ubuntu/dogpi
   source build_env/bin/activate
   twine upload --repository testpypi dist/*
   ```

3. **Test installation from TestPyPI:**
   ```bash
   pip install --index-url https://test.pypi.org/simple/ airtag-detector
   ```

### Option 2: Publish Directly to PyPI

1. **Register on PyPI** (if not already done):

   - Go to https://pypi.org/account/register/
   - Create an account and verify your email

2. **Upload to PyPI:**
   ```bash
   cd /home/ubuntu/dogpi
   source build_env/bin/activate
   twine upload dist/*
   ```

## Authentication Methods

### Method 1: Interactive Authentication

When you run `twine upload`, you'll be prompted for:

- Username: Your PyPI username
- Password: Your PyPI password (or API token)

### Method 2: API Tokens (Recommended)

1. Generate an API token:

   - PyPI: https://pypi.org/manage/account/token/
   - TestPyPI: https://test.pypi.org/manage/account/token/

2. Use token for upload:
   ```bash
   twine upload --username __token__ --password YOUR_API_TOKEN dist/*
   ```

### Method 3: Configuration File

Create `~/.pypirc`:

```ini
[distutils]
index-servers =
    pypi
    testpypi

[pypi]
username = __token__
password = YOUR_PYPI_API_TOKEN

[testpypi]
repository = https://test.pypi.org/legacy/
username = __token__
password = YOUR_TESTPYPI_API_TOKEN
```

## Complete Publishing Workflow

1. **Final build with clean environment:**

   ```bash
   cd /home/ubuntu/dogpi
   rm -rf dist/ build/ *.egg-info/
   source build_env/bin/activate
   python -m build
   twine check dist/*
   ```

2. **Upload to TestPyPI (optional but recommended):**

   ```bash
   twine upload --repository testpypi dist/*
   ```

3. **Test installation:**

   ```bash
   pip install --index-url https://test.pypi.org/simple/ airtag-detector
   ```

4. **Upload to production PyPI:**
   ```bash
   twine upload dist/*
   ```

## After Publishing

### Installation Commands for Users

**Standard installation:**

```bash
pip install airtag-detector
```

**With HomeKit support:**

```bash
pip install airtag-detector[homekit]
```

**Using pipx (recommended for end users):**

```bash
pipx install airtag-detector
pipx inject airtag-detector aiohomekit  # For HomeKit support
```

### Available Commands After Installation

- `airtag-detector` - Main detection service
- `airtag-setup` - Initial setup wizard
- `airtag-homekit-setup` - HomeKit configuration
- `airtag-test` - Bluetooth testing utility

### Package Information

- **Package Name:** airtag-detector
- **Version:** 1.0.0
- **Entry Points:** 4 command-line tools
- **Dependencies:** bleak, requests
- **Optional Dependencies:** aiohomekit (for HomeKit support)

## Troubleshooting

### Common Issues

1. **"Package already exists" error:**

   - You cannot upload the same version twice
   - Increment version in `pyproject.toml` and rebuild

2. **Authentication errors:**

   - Check your username/password or API token
   - Ensure you're using the correct repository (PyPI vs TestPyPI)

3. **Build errors:**
   - Check `pyproject.toml` syntax
   - Ensure all required files are in MANIFEST.in

### Version Management

To publish updates:

1. Update version in `pyproject.toml`
2. Clean and rebuild: `rm -rf dist/ && python -m build`
3. Upload new version: `twine upload dist/*`

## Next Steps

1. Choose your publishing method (TestPyPI first is recommended)
2. Create PyPI account if needed
3. Run the upload command
4. Update your README with installation instructions
5. Consider setting up automated publishing with GitHub Actions

---

**Ready to publish!** Your package is properly structured and passes all checks.
