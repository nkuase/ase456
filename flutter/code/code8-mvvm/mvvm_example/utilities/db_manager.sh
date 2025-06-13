#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to show usage
show_usage() {
    echo "Database Manager Script"
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  view              - Display all users in the database"
    echo "  create-sample     - Create sample users in the database"
    echo "  export <path>     - Export database to JSON file"
    echo "  import <path>     - Import database from JSON file"
    echo "  backup            - Create a backup of the database"
    echo "  restore <backup>  - Restore database from a backup"
    echo ""
    echo "Examples:"
    echo "  $0 view"
    echo "  $0 create-sample"
    echo "  $0 export ./my_backup.json"
    echo "  $0 import ./my_backup.json"
    echo "  $0 backup"
    echo "  $0 restore backups/backup_20240315_123456.json"
}

# Function to create backup
create_backup() {
    local backup_dir="$SCRIPT_DIR/backups"
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_file="$backup_dir/backup_$timestamp.json"
    
    # Create backup directory if it doesn't exist
    mkdir -p "$backup_dir"
    
    # Run the export command
    if dart "$SCRIPT_DIR/db_viewer.dart" export "$backup_file"; then
        echo "Backup created successfully at: $backup_file"
    else
        echo "Failed to create backup"
        exit 1
    fi
}

# Function to restore backup
restore_backup() {
    local backup_file="$1"
    
    if [ ! -f "$backup_file" ]; then
        echo "Error: Backup file not found at $backup_file"
        exit 1
    fi
    
    # Run the import command
    if dart "$SCRIPT_DIR/db_viewer.dart" import "$backup_file"; then
        echo "Database restored successfully from: $backup_file"
    else
        echo "Failed to restore database"
        exit 1
    fi
}

# Function to ensure dependencies are installed
ensure_dependencies() {
    echo "Checking dependencies..."
    
    # Check if pubspec.yaml exists
    if [ ! -f "$SCRIPT_DIR/pubspec.yaml" ]; then
        echo "Error: pubspec.yaml not found in $SCRIPT_DIR"
        exit 1
    fi
    
    # Check if .dart_tool directory exists
    if [ ! -d "$SCRIPT_DIR/.dart_tool" ]; then
        echo "Installing dependencies..."
        (cd "$SCRIPT_DIR" && dart pub get)
        if [ $? -ne 0 ]; then
            echo "Error: Failed to install dependencies"
            exit 1
        fi
    fi
    
    # Verify idb_shim package is installed
    if ! grep -q "idb_shim" "$SCRIPT_DIR/.dart_tool/package_config.json"; then
        echo "Installing idb_shim package..."
        (cd "$SCRIPT_DIR" && dart pub add idb_shim)
        if [ $? -ne 0 ]; then
            echo "Error: Failed to install idb_shim package"
            exit 1
        fi
    fi
    
    echo "Dependencies are up to date"
}

# Function to run dart command with error handling
run_dart_command() {
    local command="$1"
    local output
    
    output=$(dart "$SCRIPT_DIR/db_viewer.dart" $command 2>&1)
    local status=$?
    
    if [ $status -ne 0 ]; then
        echo "Error running command: $command"
        echo "$output"
        return 1
    fi
    
    echo "$output"
    return 0
}

# Main script logic
ensure_dependencies

case "$1" in
    "view")
        run_dart_command "view"
        ;;
    "create-sample")
        run_dart_command "create-sample"
        ;;
    "export")
        if [ -z "$2" ]; then
            echo "Error: Export path not specified"
            show_usage
            exit 1
        fi
        run_dart_command "export $2"
        ;;
    "import")
        if [ -z "$2" ]; then
            echo "Error: Import path not specified"
            show_usage
            exit 1
        fi
        run_dart_command "import $2"
        ;;
    "backup")
        create_backup
        ;;
    "restore")
        if [ -z "$2" ]; then
            echo "Error: Backup file not specified"
            show_usage
            exit 1
        fi
        restore_backup "$2"
        ;;
    *)
        show_usage
        exit 1
        ;;
esac 