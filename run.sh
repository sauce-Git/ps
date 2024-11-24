#!/bin/bash

function run {
  # Set file name
  local file_name

  if [ -z "$1" ]; then
    file_name="solution.cpp"
  else
    file_name=$1
  fi

  # Check if the solution file exists
  if [ -f "solution.cpp" ]; then
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
    ./solution
  else
    echo "solution file not found!"
  fi
}

run
