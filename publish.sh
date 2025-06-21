#!/bin/bash

# PyPI Publishing Script for AirTag Detector
# Usage: ./publish.sh [testpypi|pypi]

set -e

REPO=${1:-testpypi}
PROJECT_DIR="/home/ubuntu/dogpi"

echo "🚀 AirTag Detector Publishing Script"
echo "Target: $REPO"
echo "======================================"

cd "$PROJECT_DIR"

# Activate virtual environment
echo "📦 Activating build environment..."
source build_env/bin/activate

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf dist/ build/ *.egg-info/

# Build package
echo "🔨 Building package..."
python -m build

# Check package
echo "✅ Checking package..."
twine check dist/*

# Show built files
echo "📋 Built files:"
ls -la dist/

# Upload based on target
if [ "$REPO" = "pypi" ]; then
    echo "🌍 Uploading to PyPI (production)..."
    echo "⚠️  This will publish to the live PyPI repository!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        twine upload dist/*
        echo "🎉 Successfully published to PyPI!"
        echo "📦 Install with: pip install airtag-detector"
    else
        echo "❌ Publication cancelled."
        exit 1
    fi
elif [ "$REPO" = "testpypi" ]; then
    echo "🧪 Uploading to TestPyPI..."
    twine upload --repository testpypi dist/*
    echo "🎉 Successfully published to TestPyPI!"
    echo "🧪 Test install with: pip install --index-url https://test.pypi.org/simple/ airtag-detector"
else
    echo "❌ Invalid repository. Use 'testpypi' or 'pypi'"
    exit 1
fi

echo "📝 Don't forget to:"
echo "   1. Test the installation"
echo "   2. Update documentation if needed"
echo "   3. Create a git tag for this version"
echo "   4. Consider setting up automated publishing"
