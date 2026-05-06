#!/bin/bash

# ZenTimer Flutter - Quick Start Script
# This script sets up and runs the ZenTimer Flutter app

set -e

echo "🚀 ZenTimer Flutter - Quick Start"
echo "=================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Flutter installation
echo -e "${BLUE}Checking Flutter installation...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${YELLOW}Flutter not found. Please install Flutter from https://flutter.dev/docs/get-started/install${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Flutter is installed${NC}"
flutter --version
echo ""

# Navigate to project directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo -e "${BLUE}Installing dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Check which platform to run
echo "Select platform to run:"
echo "1) Web (Chrome)"
echo "2) iOS (Simulator)"
echo "3) Android (Emulator)"
echo "4) Physical Device"
echo "5) Just build for web"
echo "6) Exit"
echo ""
read -p "Enter choice (1-6): " choice

case $choice in
    1)
        echo -e "${BLUE}Starting web app in Chrome...${NC}"
        flutter run -d chrome
        ;;
    2)
        echo -e "${BLUE}Starting iOS simulator...${NC}"
        flutter run -d iphone
        ;;
    3)
        echo -e "${BLUE}Starting on Android emulator...${NC}"
        flutter run -d android
        ;;
    4)
        echo -e "${BLUE}Connecting to physical device...${NC}"
        flutter devices
        flutter run
        ;;
    5)
        echo -e "${BLUE}Building for web...${NC}"
        flutter build web --release
        echo -e "${GREEN}✓ Web build complete at: build/web/${NC}"
        ;;
    6)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo -e "${YELLOW}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Done! 🎉${NC}"
