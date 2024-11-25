#!/bin/bash

declare -r BACKUP_DIR="./backup"
declare -r TEMPLATE_DIR="./template"

function run_solution {
  # Check if the solution file exists
  if [ -f $1 ]; then
    # Compile the solution
    echo "Compiling the solution"
    g++ -o solution solution.cpp
  else
    # Exit if the solution file does not exist
    echo "solution.cpp file not found!"
    exit 1
  fi

  # Run the solution
  if [ -f "solution" ]; then
    echo "Running the solution"
    echo "----------------------------------------"
    ./solution
    echo "----------------------------------------"
  else
    echo "solution file not found!"
  fi
}

function backup_solution {
  # Check if the solution file exists
  if [ -f "./solution.cpp" ]; then
    local today=$(date +"%Y-%m-%d")
    local time=$(date +"%H:%M:%S")
    local backup_dir_path="./${BACKUP_DIR}/$today"
    local backup_file_path="$backup_dir_path/$time.cpp"
    # Copy the solution to the backup file
    echo "Copying the solution to backup.cpp"
    mkdir -p $backup_dir_path
    cp ./solution.cpp $backup_file_path
  else
    # Exit if the solution file does not exist
    echo "solution.cpp file not found!"
    exit 1
  fi
}

function refresh_template {
  # Check if the template file exists
  if [ -f "./${TEMPLATE_DIR}/template.cpp" ]; then
    # Copy the template to the solution file
    echo "Copying the template to solution.cpp"
    cp ./template/template.cpp solution.cpp
  else
    # Exit if the template file does not exist
    echo "template.cpp file not found!"
    exit 1
  fi
}

function create_directory {
  # Check if the backup directory exists
  if [ ! -d "./$BACKUP_DIR" ]; then
    # Create the backup directory
    echo "Creating the backup directory"
    mkdir $BACKUP_DIR
  fi
  # Check if the template directory exists
  if [ ! -d "./$TEMPLATE_DIR" ]; then
    # Create the template directory
    echo "Creating the template directory"
    mkdir $TEMPLATE_DIR
  fi
}

function help {
  echo "Usage: run.sh [OPTION]..."
  echo "Run the solution.cpp file"
  echo ""
  echo "Options:"
  echo "  -r, --refresh  Refresh the solution.cpp file with the template"
  echo "  -b, --backup   Backup the solution.cpp file"
  echo "  -f, --file     Specify the file name to run"
  echo "  -h, --help     Display this help and exit"
}

function main {
  # Check if refresh argument is given like --refresh
  local refresh=false
  local backup=false
  local clean_backup=false
  local file_name="solution.cpp"

  # Check the arguments
  # If --help or -h is given, show the help
  if [[ $1 == "--help" || $1 == "-h" ]]; then
    help
    exit 0
  fi
  # Check the arguments
  for arg in $@; do
    if [[ $arg == "--refresh" || $arg == "-r" ]]; then
      refresh=true
      backup=true
    elif [[ $arg == "--backup" || $arg == "-b" ]]; then
      backup=true
    elif [[ $arg == "--clean-backup" || $arg == "-cb" ]]; then
      clean_backup=true
    elif [[ $arg == "--file" || $arg == "-f" ]]; then
      file_name=$arg
    fi
  done

  # Clean the backup directory
  if [[ $clean_backup == true ]]; then
    echo "Cleaning the backup directory"
    rm -rf $BACKUP_DIR
    create_directory
    echo "Backup directory cleaned"
    exit 0
  fi

  # Create the backup and template directory
  create_directory

  # Backup the solution
  if [[ $backup == true ]]; then
    echo "Backup the solution"
    backup_solution
    echo "Backup completed"
  fi
  # Refresh the template
  if [[ $refresh == true ]]; then
    echo "Refresh the template"
    refresh_template
    echo "Refresh completed"
  fi
  # Run the solution
  if [[ $refresh == false && $backup == false ]]; then
    echo "Run the solution"
    run_solution $file_name
    echo "Run completed"
  fi
}

main "$@"
