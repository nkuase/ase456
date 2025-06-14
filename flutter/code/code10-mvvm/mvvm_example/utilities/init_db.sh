#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Function to show usage
show_usage() {
    echo "Database Initialization Script"
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --help     - Show this help message"
    echo "  --force    - Force initialization even if database exists"
    echo ""
    echo "This script will:"
    echo "1. Create the database directory if it doesn't exist"
    echo "2. Copy the sample data to the database"
    echo "3. Initialize the command-line tool's database"
}

# Parse command line arguments
FORCE=false
for arg in "$@"; do
    case $arg in
        --force)
            FORCE=true
            shift
            ;;
        --help)
            show_usage
            exit 0
            ;;
    esac
done

# Check if database already exists
DB_DIR="$HOME/.mvvm_example"
DB_FILE="$DB_DIR/users.json"

if [ -f "$DB_FILE" ] && [ "$FORCE" = false ]; then
    echo "Database already exists at $DB_FILE"
    echo "Use --force to overwrite it"
    exit 1
fi

# Create database directory
echo "Creating database directory..."
mkdir -p "$DB_DIR"

# Copy sample data
echo "Copying sample data..."
cp "$PROJECT_ROOT/assets/data/sample_users.json" "$DB_FILE"

# Initialize command-line tool database
echo "Initializing command-line tool database..."
"$SCRIPT_DIR/db_manager.sh" import "$DB_FILE"

echo "Database initialization complete!"
echo "Database location: $DB_FILE"
echo ""
echo "You can now:"
echo "1. View the database: $SCRIPT_DIR/db_manager.sh view"
echo "2. Export the database: $SCRIPT_DIR/db_manager.sh export <path>"
echo "3. Import the database: $SCRIPT_DIR/db_manager.sh import <path>" 