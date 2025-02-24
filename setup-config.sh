#!/bin/bash

# setup-configs.sh - Prepares configuration files by substituting environment variables

# Load environment variables from .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
  echo "Loaded environment variables from .env file"
else
  echo "Warning: .env file not found"
fi

# Set default values for environment variables if not set
: ${PROMETHEUS_PORT:=9090}
: ${ALERTMANAGER_PORT:=9093}
: ${NODE_EXPORTER_PORT:=9100}
: ${CADVISOR_PORT:=8080}
: ${BLACKBOX_EXPORTER_PORT:=9115}
: ${TELEGRAF_PORT:=9273}
: ${LOKI_PORT:=3100}
: ${GRAFANA_PORT:=3000}

# Export all variables so envsubst can use them
export PROMETHEUS_PORT
export ALERTMANAGER_PORT
export NODE_EXPORTER_PORT
export CADVISOR_PORT
export BLACKBOX_EXPORTER_PORT
export TELEGRAF_PORT
export LOKI_PORT
export GRAFANA_PORT

echo "Using environment variables:"
echo "PROMETHEUS_PORT=$PROMETHEUS_PORT"
echo "ALERTMANAGER_PORT=$ALERTMANAGER_PORT"
echo "NODE_EXPORTER_PORT=$NODE_EXPORTER_PORT"
echo "CADVISOR_PORT=$CADVISOR_PORT"
echo "BLACKBOX_EXPORTER_PORT=$BLACKBOX_EXPORTER_PORT"
echo "TELEGRAF_PORT=$TELEGRAF_PORT"
echo "LOKI_PORT=$LOKI_PORT"
echo "GRAFANA_PORT=$GRAFANA_PORT"

# Function to process a configuration file
process_config() {
  local template_file="$1"
  local output_file="$2"
  
  if [ -f "$template_file" ]; then
    echo "Processing $template_file -> $output_file"
    # Create output directory if it doesn't exist
    mkdir -p "$(dirname "$output_file")"
    
    # Define the variables to be substituted
    VARS='$PROMETHEUS_PORT $ALERTMANAGER_PORT $NODE_EXPORTER_PORT $CADVISOR_PORT $BLACKBOX_EXPORTER_PORT $TELEGRAF_PORT $LOKI_PORT $GRAFANA_PORT $SMTP_FROM $SMTP_SMARTHOST $SMTP_AUTH_USERNAME $SMTP_AUTH_PASSWORD $ALERT_EMAIL_TO $SLACK_WEBHOOK_URL'
    
    # Replace environment variables and create the final config
    envsubst "$VARS" < "$template_file" > "$output_file"
    echo "✓ Generated $(basename "$output_file")"
  else
    echo "✗ Template file not found: $template_file"
    if [ -f "${output_file}" ]; then
      echo "Using existing $(basename "$output_file") as fallback"
    else
      echo "No fallback found for $(basename "$output_file")"
    fi
  fi
}

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

# Verify variable substitution
check_unsubstituted_vars() {
  local file="$1"
  if [ -f "$file" ]; then
    echo "Checking for unsubstituted variables in $file"
    if grep -q '\$[A-Z_]\+' "$file" || grep -q '\${[A-Z_]\+' "$file"; then
      echo "Warning: Unsubstituted variables found in $file"
      grep '\$[A-Z_]\+' "$file" || grep '\${[A-Z_]\+' "$file"
    else
      echo "✓ All variables substituted in $file"
    fi
  fi
}

check_unsubstituted_vars "./prometheus/prometheus.yml"
check_unsubstituted_vars "./alertmanager/alertmanager.yml"

echo "=== Configuration preparation completed ==="
echo "You can now run: docker-compose up -d"