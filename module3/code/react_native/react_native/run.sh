#!/bin/bash

# React Native App - Run Script
# This script installs dependencies and starts the Expo development server

set -e  # Exit on error

echo "================================================"
echo "React Native Examples - Setup and Run"
echo "================================================"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if node is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not available. Please install npm."
    exit 1
fi

echo -e "${BLUE}Node version: $(node -v)${NC}"
echo -e "${BLUE}NPM version: $(npm -v)${NC}"
echo ""

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo -e "${GREEN}Installing dependencies...${NC}"
    echo -e "${YELLOW}This may take a few minutes...${NC}"
    echo ""
    npm install
    echo ""
    echo -e "${GREEN}✓ Dependencies installed!${NC}"
else
    echo -e "${GREEN}Dependencies already installed.${NC}"
fi

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}Starting Expo development server...${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo -e "${BLUE}Options to run the app:${NC}"
echo -e "  • Press ${BLUE}w${NC} - Open in web browser (quick preview)"
echo -e "  • Press ${BLUE}i${NC} - Open iOS simulator (Mac only)"
echo -e "  • Press ${BLUE}a${NC} - Open Android emulator"
echo -e "  • ${BLUE}Scan QR code${NC} with Expo Go app on your phone"
echo ""
echo -e "${YELLOW}📱 To test on your phone:${NC}"
echo -e "  1. Install 'Expo Go' app from App Store or Play Store"
echo -e "  2. Scan the QR code that appears below"
echo ""
echo -e "Press ${BLUE}Ctrl+C${NC} to stop the server"
echo ""

# Start Expo dev server
npx expo start
