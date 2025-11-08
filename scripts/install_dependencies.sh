#!/bin/bash

echo "Installing dependencies for BijbelQuiz..."

# Update package list
sudo apt update

# Install CMake (required for Linux development)
echo "Installing CMake..."
sudo apt install -y cmake

# Install other common dependencies
echo "Installing additional dependencies..."
sudo apt install -y clang libgtk-3-dev ninja-build pkg-config

echo "Dependencies installed successfully!"
echo "You can now run: flutter run -d linux" 