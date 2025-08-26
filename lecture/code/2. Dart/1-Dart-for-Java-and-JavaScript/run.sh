#!/bin/bash

# Script to run all Dart files and report their execution status
# Usage: ./run_dart_files.sh [directory_path]
# If no directory is provided, it will search in the current directory

echo "=== Dart File Runner ==="
echo "Testing all Dart files for compilation and execution errors..."
echo

# Set the directory to search for Dart files
# Use provided argument or default to current directory
#	`${1}` refers to the first positional argument passed to the script or function.
#	The `:-.` part provides a default value: if no first argument is provided (i.e., `$1` is empty or unset), the value will be `.` (which means the current directory).
SEARCH_DIR="${1:-.}"

# Check if dart command is available
if ! command -v dart &> /dev/null; then
    echo "ERROR: Dart SDK not found. Please install Dart SDK first."
    exit 1
fi

# Find all .dart files in the specified directory
dart_files=$(find "$SEARCH_DIR" -name "*.dart" -type f)

# Check if any dart files were found
if [ -z "$dart_files" ]; then
    echo "No Dart files found in directory: $SEARCH_DIR"
    exit 1
fi

# Initialize counters
total_files=0
success_count=0
error_count=0

# Array to store failed files
failed_files=()

echo "Found Dart files to test:"
echo "$dart_files"
echo
echo "Starting execution tests..."
echo "----------------------------------------"

# Loop through each dart file
while IFS= read -r dart_file; do
    if [ -n "$dart_file" ]; then
        total_files=$((total_files + 1))
        printf "Testing: %s ... " "$dart_file"
        
        # Run the dart file and capture output and exit status
        # Redirect both stdout and stderr to /dev/null to keep output clean
        if dart run "$dart_file" >/dev/null 2>&1; then
            echo "OK"
            success_count=$((success_count + 1))
        else
            echo "ERROR"
            error_count=$((error_count + 1))
            failed_files+=("$dart_file")
            
            # Optional: Show the actual error (uncomment next lines if needed)
            # echo "  Error details:"
            # dart run "$dart_file" 2>&1 | sed 's/^/    /'
        fi
    fi
done <<< "$dart_files"

# Print summary
echo "----------------------------------------"
echo "Execution Summary:"
echo "Total files tested: $total_files"
echo "Successful: $success_count"
echo "Errors: $error_count"

# Show failed files if any
if [ $error_count -gt 0 ]; then
    echo
    echo "Files that failed to execute:"
    for failed_file in "${failed_files[@]}"; do
        echo "  - $failed_file"
    done
fi

# Exit with appropriate code
if [ $error_count -eq 0 ]; then
    echo "All Dart files executed successfully! ✅"
    exit 0
else
    echo "Some Dart files failed to execute! ❌"
    exit 1
fi