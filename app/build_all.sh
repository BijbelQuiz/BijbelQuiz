#!/bin/bash

# BijbelQuiz Build Script
# This script builds the app for all supported platforms

set -e  # Exit on any error

echo "🚀 Starting BijbelQuiz build process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | grep -o "Flutter [0-9]\+\.[0-9]\+\.[0-9]\+" | head -1)
print_status "Using $FLUTTER_VERSION"

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean

# Get dependencies
print_status "Getting dependencies..."
flutter pub get

# Run tests
print_status "Running tests..."
flutter test

# Run analysis
print_status "Running code analysis..."
if ! flutter analyze; then
    print_warning "Code analysis found issues, but continuing build."
else
    print_success "Code analysis passed."
fi

# Create build directory
BUILD_DIR="builds/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BUILD_DIR"

print_status "Builds will be saved to: $BUILD_DIR"

# Build for Android
print_status "Building for Android..."
if flutter build apk --release; then
    cp build/app/outputs/flutter-apk/app-release.apk "$BUILD_DIR/bijbelquiz-android.apk"
    print_success "Android APK built successfully"
else
    print_warning "Android build failed - skipping"
fi

# Build Android App Bundle for Play Store
print_status "Building Android App Bundle..."
if flutter build appbundle --release; then
    cp build/app/outputs/bundle/release/app-release.aab "$BUILD_DIR/bijbelquiz-android.aab"
    print_success "Android App Bundle built successfully"
else
    print_warning "Android App Bundle build failed - skipping"
fi

# Build for Web
print_status "Building for Web..."
if flutter build web --release; then
    cp -r build/web "$BUILD_DIR/web"
    print_success "Web build completed successfully"
else
    print_warning "Web build failed - skipping"
fi

# Build for Linux
print_status "Building for Linux..."
if flutter build linux --release; then
    cp -r build/linux/x64/release/bundle "$BUILD_DIR/linux"
    print_success "Linux build completed successfully"
else
    print_warning "Linux build failed - skipping"
fi

# Build for Windows
print_status "Building for Windows..."
if flutter build windows --release; then
    cp -r build/windows/runner/Release "$BUILD_DIR/windows"
    print_success "Windows build completed successfully"
else
    print_warning "Windows build failed - skipping"
fi

# Build for macOS
print_status "Building for macOS..."
if flutter build macos --release; then
    cp -r build/macos/Build/Products/Release "$BUILD_DIR/macos"
    print_success "macOS build completed successfully"
else
    print_warning "macOS build failed - skipping"
fi

# Build for iOS (requires macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_status "Building for iOS..."
    if flutter build ios --release; then
        cp -r build/ios/iphoneos "$BUILD_DIR/ios"
        print_success "iOS build completed successfully"
    else
        print_warning "iOS build failed - skipping"
    fi
else
    print_warning "iOS build skipped (requires macOS)"
fi

# Generate build report
print_status "Generating build report..."
cat > "$BUILD_DIR/build_report.txt" << EOF
BijbelQuiz Build Report
======================

Build Date: $(date)
Flutter Version: $FLUTTER_VERSION
Build Directory: $BUILD_DIR

Platform Builds:
$(ls -la "$BUILD_DIR" | grep -E "\.(apk|aab|web|linux|windows|macos|ios)" || echo "No builds found")

Build Commands Used:
- flutter clean
- flutter pub get
- flutter test
- flutter analyze
- flutter build apk --release
- flutter build appbundle --release
- flutter build web --release
- flutter build linux --release
- flutter build windows --release
- flutter build macos --release
- flutter build ios --release (macOS only)

EOF

print_success "Build process completed!"
print_status "Build artifacts saved to: $BUILD_DIR"
print_status "Build report saved to: $BUILD_DIR/build_report.txt"

# Show build summary
echo ""
echo "📋 Build Summary:"
echo "=================="
ls -la "$BUILD_DIR"

echo ""
print_status "Next steps:"
echo "1. Test the builds on target platforms"
echo "2. Sign the Android APK/AAB for Play Store"
echo "3. Package iOS app for App Store"
echo "4. Deploy web version to hosting platform"
echo "5. Distribute desktop versions"

echo ""
print_success "🎉 BijbelQuiz is ready for release!"