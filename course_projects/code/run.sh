#!/bin/bash
set -e

# The source directory name should be "_$PROJECT_NAME"

#PROJECT_NAME="p1_unit_conversion"
#PROJECT_NAME="p2_calculator"
#PROJECT_NAME="p3_movie" # Make sure you have the correct KEY (/lib/util/api.dart)
#PROJECT_NAME="p4_weather" # Make sure you have the correct KEY (/lib/services/weather.dart)
PROJECT_NAME="p5_expense"

echo "Checking for Flutter installation..."
if ! command -v flutter &> /dev/null; then
  echo "Flutter not found. Please install Flutter: https://docs.flutter.dev/get-started/install"
  exit 1
fi

if [ -d "$PROJECT_NAME" ]; then
  echo "Directory $PROJECT_NAME already exists. Please remove it or choose another project name."
  exit 1
fi

echo "Creating new Flutter project: $PROJECT_NAME"
flutter create "$PROJECT_NAME"

echo 'Copying all the files in "_$PROJECT_NAME" to "$PROJECT_NAME"'
cp -r "_$PROJECT_NAME/"* "$PROJECT_NAME/"

cd "$PROJECT_NAME"

echo "Installing Flutter dependencies..."
flutter pub get

if [ ! -d ".git" ]; then
  echo "Initializing git repository..."
  git init
  git add .
  git commit -m "Initial commit with copied code"
fi

echo "Flutter project '$PROJECT_NAME' setup complete and ready for development!"

