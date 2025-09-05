#!/bin/bash

# BijbelQuiz Build Script
# This script sets up the environment variables and builds the app

echo "🚀 Setting up environment variables..."

echo "✅ Environment variables set"
echo "📱 Building BijbelQuiz..."

# Check if build target is specified
if [ "$1" = "android" ]; then
    echo "🔨 Building for Android..."
    flutter build apk --release
elif [ "$1" = "ios" ]; then
    echo "🍎 Building for iOS..."
    flutter build ios --release
elif [ "$1" = "web" ]; then
    echo "🌐 Building for Web..."
    flutter build web --release
elif [ "$1" = "linux" ]; then
    echo "🐧 Building for Linux..."
    flutter build linux --release
elif [ "$1" = "macos" ]; then
    echo "🍎 Building for macOS..."
    flutter build macos --release
elif [ "$1" = "windows" ]; then
    echo "🪟 Building for Windows..."
    flutter build windows --release
else
    echo "🔨 Building for all platforms..."
    echo "Available targets: android, ios, web, linux, macos, windows"
    echo "Usage: ./build.sh [target]"
    echo ""
    echo "Building for Android by default..."
    flutter build apk --release
fi

echo "✅ Build completed!" 