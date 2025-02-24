#!/bin/bash

# Define the base directory
BASE_DIR="monitoring-stack"

# Create base directory
echo "Creating project structure in $BASE_DIR..."
mkdir -p $BASE_DIR

# Change to the base directory
cd $BASE_DIR

# Create .env and docker-compose.yml files
touch .env
touch docker-compose.yml

# Create prometheus directory and files
mkdir -p prometheus/alerts
touch prometheus/prometheus.yml
touch prometheus/alert.rules
touch prometheus/alerts/custom_alerts.yml

# Create grafana directory and files
mkdir -p grafana/provisioning/dashboards
mkdir -p grafana/provisioning/datasources
mkdir -p grafana/dashboards
touch grafana/provisioning/dashboards/dashboard.yml
touch grafana/provisioning/dashboards/node_exporter_dashboard.json
touch grafana/provisioning/datasources/datasource.yml

# Create alertmanager directory and files
mkdir -p alertmanager
touch alertmanager/alertmanager.yml

# Create node_exporter directory
mkdir -p node_exporter

# Create cadvisor directory
mkdir -p cadvisor

# Create blackbox_exporter directory and files
mkdir -p blackbox_exporter
touch blackbox_exporter/blackbox.yml

# Create loki directory and files
mkdir -p loki
touch loki/loki-config.yml

# Create promtail directory and files
mkdir -p promtail
touch promtail/promtail-config.yml

# # Make the script executable
# chmod +x setup.sh

echo "Project structure created successfully!"
echo "Directory structure:"
find . -type d -not -path "*/\.*" | sort

echo "Files created:"
find . -type f -not -path "*/\.*" | sort