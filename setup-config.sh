#!/bin/bash

# setup-configs.sh - Prepares configuration files by substituting environment variables
# Load environment variables from .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
  echo "Loaded environment variables from .env file"
else
  echo "Warning: .env file not found"
fi

# Function to process a configuration file
process_config() {
  local template_file="$1"
  local output_file="$2"
  
  if [ -f "$template_file" ]; then
    echo "Processing $template_file -> $output_file"
    # Create output directory if it doesn't exist
    mkdir -p "$(dirname "$output_file")"
    # Replace environment variables and create the final config
    envsubst < "$template_file" > "$output_file"
    echo "✓ Generated $(basename "$output_file")"
  else
    echo "✗ Template file not found: $template_file"
  fi
}

# # Create directory structure if it doesn't exist
# mkdir -p ./alertmanager
# mkdir -p ./loki
# mkdir -p ./prometheus
# mkdir -p ./telegraf
# mkdir -p ./grafana/provisioning
# mkdir -p ./blackbox_exporter
# mkdir -p ./promtail

echo "=== Processing configuration files ==="

# Alertmanager configuration
process_config "./alertmanager/alertmanager.yml.template" "./alertmanager/alertmanager.yml"

# Prometheus configuration
process_config "./prometheus/prometheus.yml.template" "./prometheus/prometheus.yml"

# Loki configuration
process_config "./loki/loki-config.yml.template" "./loki/loki-config.yml"

# Telegraf configuration
process_config "./telegraf/telegraf.conf.template" "./telegraf/telegraf.conf"

# Blackbox exporter configuration
process_config "./blackbox_exporter/blackbox.yml.template" "./blackbox_exporter/blackbox.yml"

# Promtail configuration
process_config "./promtail/promtail-config.yml.template" "./promtail/promtail-config.yml"

echo "=== Configuration preparation completed ==="
echo "You can now run: docker-compose up -d"