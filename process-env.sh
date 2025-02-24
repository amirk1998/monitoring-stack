#!/bin/bash

# Script for processing environment variables in configuration files
# Save this as process-env.sh in your project root directory

# Function to replace environment variables in a file
process_env_vars() {
  local file=$1
  local temp_file="${file}.tmp"
  
  # Create a copy of the original file
  cp "$file" "$temp_file"
  
  # Replace all ${VAR} occurrences with their values
  envsubst < "$temp_file" > "$file"
  
  # Remove temporary file
  rm "$temp_file"
  
  echo "Processed environment variables in $file"
}

# Process all configuration files
process_env_vars "./prometheus/prometheus.yml"
process_env_vars "./alertmanager/alertmanager.yml"
process_env_vars "./telegraf/telegraf.conf"
# Add more files as needed

echo "All configuration files processed"

# If this script is used as an entrypoint, execute the passed command
exec "$@"