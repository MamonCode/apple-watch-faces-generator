#!/bin/bash

# Apple Watch Faces Generator Installer
# This script sets up the development environment

echo "Setting up Apple Watch Faces Generator..."

# Create directory structure
mkdir -p src/{ios,watchos,shared}
mkdir -p Resources/{Faces,Icons}
mkdir -p Tests/{Unit,Integration}

# Install dependencies (if using package manager)
if command -v swift &> /dev/null; then
    echo "Swift found - setting up Xcode project"
    # Xcode project setup commands would go here
fi

# Set permissions
chmod +x installer.sh

echo "Setup complete!"
echo "Next steps:"
echo "1. Open in Xcode"
echo "2. Add sample.watchface to Resources/Faces"
echo "3. Run tests"
