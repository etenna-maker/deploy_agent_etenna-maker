

#!/bin/bash

# ============================================================
# setup_project.sh
# Project: Student Attendance Tracker
# Author: Elnathan Mulugeta
# Github: etenna-maker
# Descrpition: This scrpit will automate the setup of the 
#              Student Attendance
# ============================================================

# Stop the script if any command fails
set -e

# Store the directory where the script is running from
SCRIPT_DIR=$(pwd)
# ============================================================
# SECTION 1: TRAP - Ctrl+C
# ============================================================

# save_and_exit runs when user presses Ctrl+C
save_and_exit() {
    echo ""
    echo "Script interrupted. Saving progress..."

    # Check if project folder exists
    if [ -d "$PROJECT_DIR" ]; then
        # Bundle folder into compressed archive
        tar -czf "${PROJECT_DIR}_archive.tar.gz" "$PROJECT_DIR"
        # Delete incomplete folder
        rm -rf "$PROJECT_DIR"
        echo "Archive created: ${PROJECT_DIR}_archive.tar.gz"
    else
        echo "No folder to archive. Exiting."
    fi
    exit 1
}

# Listen for Ctrl+C and run save_and_exit
trap save_and_exit SIGINT

# ============================================================
echo "Setup started at: $(date)"


# SECTION 2: WELCOME MESSAGE
# ============================================================

echo "=================================="
echo " Student Attendance Tracker Setup"
echo "=================================="
echo "" 

# ============================================================
# SECTION 3: GET PROJECT NAME FROM USER
# ============================================================

# Ask user to type a project name
read -p "Enter your project name: " PROJECT_NAME

# Check if user typed nothing
if [ -z "$PROJECT_NAME" ]; then
    echo "Error: Project name cannot be empty!"
    exit 1
fi

# Build the folder name using user input
PROJECT_DIR="attendance_tracker_${PROJECT_NAME}"
echo "Project will be created at: $PROJECT_DIR"
echo "" 

# ============================================================
# SECTION 4: CREATE DIRECTORY STRUCTURE
# ============================================================

# Check if folder already exists
if [ -d "$PROJECT_DIR" ]; then
    echo "Warning: $PROJECT_DIR already exists!"
    read -p "Overwrite it? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo "Exiting without changes."
        exit 0
    fi
    rm -rf "$PROJECT_DIR"
fi

# Create the main project folder
mkdir "$PROJECT_DIR"

# Create Helpers and reports subfolders
mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

echo "Project structure created successfully."       

# ============================================================
# SECTION 5: COPY SOURCE FILES
# ============================================================

echo "Copying project files..."

# Copy main python file to root of project
cp attendance_checker.py "$PROJECT_DIR/attendance_checker.py"

# Copy assets and config into Helpers folder
cp assets.csv "$PROJECT_DIR/Helpers/assets.csv"
cp config.json "$PROJECT_DIR/Helpers/config.json"

# Copy reports log into reports folder
cp reports.log "$PROJECT_DIR/reports/reports.log"

echo "All files copied successfully."
echo ""

# ============================================================
# SECTION 6: UPDATE CONFIG WITH SED
# ============================================================

echo "Current thresholds: Warning=75% Failure=50%"
read -p "Do you want to update the thresholds? (yes/no): " UPDATE

if [ "$UPDATE" = "yes" ]; then

    # Get new warning value
    read -p "Enter new Warning threshold (default 75): " WARN_VAL
    if ! [[ "$WARN_VAL" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Using default: 75"
        WARN_VAL=75
    fi

    # Get new failure value
    read -p "Enter new Failure threshold (default 50): " FAIL_VAL
    if ! [[ "$FAIL_VAL" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Using default: 50"
        FAIL_VAL=50
    fi

    # Failure must be less than warning
    if [ "$FAIL_VAL" -ge "$WARN_VAL" ]; then
        echo "Failure must be less than Warning. Using defaults."
        WARN_VAL=75
        FAIL_VAL=50
    fi

    # Use sed to edit config.json in place
    sed -i '' "s/\"warning\": [0-9]*/\"warning\": $WARN_VAL/" "$PROJECT_DIR/Helpers/config.json"
    sed -i '' "s/\"failure\": [0-9]*/\"failure\": $FAIL_VAL/" "$PROJECT_DIR/Helpers/config.json"

    echo "Config updated:"
    cat "$PROJECT_DIR/Helpers/config.json"

else
    echo "Keeping default thresholds."
fi
echo ""

# ============================================================
# SECTION 7: HEALTH CHECK
# ============================================================

echo "Running Health Check..."
echo ""

# Check if python3 is installed
if python3 --version 2>/dev/null; then
    echo "Python3 is installed and ready."
else
    echo "Warning: Python3 is not installed!"
fi

echo ""
echo "Checking project structure..."

# Track if all files exist
CHECK_PASS=true

for ITEM in \
    "$PROJECT_DIR/attendance_checker.py" \
    "$PROJECT_DIR/Helpers" \
    "$PROJECT_DIR/Helpers/assets.csv" \
    "$PROJECT_DIR/Helpers/config.json" \
    "$PROJECT_DIR/reports" \
    "$PROJECT_DIR/reports/reports.log"
do
    if [ -e "$ITEM" ]; then
        echo "Found: $ITEM"
    else
        echo "MISSING: $ITEM"
        CHECK_PASS=false
    fi
done

echo ""
if [ "$CHECK_PASS" = true ]; then
    echo "All checks passed!"
else
    echo "Some files are missing. Check output above."
fi
echo ""

# ============================================================
# SECTION 8: SETUP COMPLETE
# ============================================================

echo "=================================="
echo " Setup Complete!"
echo "=================================="
echo ""
echo "Project location: ./$PROJECT_DIR"
echo ""
echo "To run the tracker:"
echo "  cd $PROJECT_DIR"
echo "  python3 attendance_checker.py"
echo ""
echo "To trigger the archive feature:"
echo "  Press Ctrl+C while the script is running"
echo "Setup finished at: $(date)"
echo "=================================="








