# DevOps Monitoring Stack

A comprehensive, Docker-based monitoring solution for modern infrastructure and applications. This stack provides full observability with metrics, logs, and alerts using industry-standard open-source tools.

<!-- ![Grafana Dashboard](https://via.placeholder.com/800x400?text=Monitoring+Dashboard) -->

## 🔍 Overview

This project delivers a complete monitoring infrastructure as code, allowing you to quickly deploy a production-ready monitoring solution. The stack includes:

- **Metrics collection**: Prometheus, Node Exporter, cAdvisor, Telegraf
- **Log aggregation**: Loki, Promtail
- **Alerting**: Alertmanager with email and Slack integration
- **Visualization**: Grafana with pre-configured dashboards
- **Endpoint monitoring**: Blackbox Exporter for HTTP/HTTPS/TCP checks

This monitoring solution is designed to provide immediate visibility into your infrastructure while remaining highly customizable to meet specific requirements.

## 🚀 Features

- **Zero-configuration deployment** - Works out of the box with sensible defaults
- **Environment-based configuration** - Easily customize via `.env` file
- **Template-based configuration files** - All configuration files use templates for easy customization
- **Comprehensive metrics collection** - From system metrics to container stats
- **Centralized logging** - Aggregate and search logs from all systems
- **Multi-channel alerting** - Email, Slack, and more
- **Pre-built dashboards** - Hit the ground running with ready-to-use dashboards
- **Secure by default** - Authentication enabled for all components
- **Docker-compose deployment** - Simple to deploy and manage
- **Development-friendly** - Includes MailHog for testing email alerts locally

## 📋 Requirements

- Docker Engine (19.03.0+)
- Docker Compose (1.27.0+)
- 2GB+ RAM recommended
- 10GB+ disk space

## 🛠️ Quick Start

1. **Clone the repository**

   ```bash
   git clone git@github.com:amirk1998/monitoring-stack.git
   cd devops-monitoring-stack
   ```

2. **Configure your environment**

   ```bash
   cp .env.example .env
   # Edit .env file with your preferred settings
   ```

3. **Generate configuration files**

   ```bash
   ./setup-config.sh
   ```

4. **Launch the stack**

   ```bash
   docker-compose up -d
   ```

5. **Access the dashboards**

   - Grafana: http://localhost:3000 (default credentials: admin/ChangeMe123!)
   - Prometheus: http://localhost:9090
   - Alertmanager: http://localhost:9093
   - MailHog (development only): http://localhost:8025

## 📊 Stack Components

### Core Monitoring

| Component        | Description                                | Port |
| ---------------- | ------------------------------------------ | ---- |
| **Prometheus**   | Time-series database and metrics collector | 9090 |
| **Grafana**      | Visualization and dashboarding platform    | 3000 |
| **Alertmanager** | Alert handling and routing                 | 9093 |

### Metrics Collection

| Component             | Description                                      | Port |
| --------------------- | ------------------------------------------------ | ---- |
| **Node Exporter**     | Host system metrics (CPU, memory, disk, network) | 9100 |
| **cAdvisor**          | Container metrics and resource usage             | 8080 |
| **Blackbox Exporter** | Probes endpoints over HTTP, HTTPS, DNS, TCP      | 9115 |
| **Telegraf**          | Pluggable metrics collection agent               | 9273 |

### Logging

| Component    | Description                 | Port |
| ------------ | --------------------------- | ---- |
| **Loki**     | Log aggregation system      | 3100 |
| **Promtail** | Log collector and forwarder | -    |

### Development Tools

| Component   | Description                            | Port       |
| ----------- | -------------------------------------- | ---------- |
| **MailHog** | SMTP testing server with web interface | 1025, 8025 |

## ⚙️ Configuration

### Directory Structure

```
.
├── alertmanager/               # Alertmanager configuration
├── blackbox_exporter/          # Blackbox Exporter configuration
├── grafana/                    # Grafana dashboards and datasources
├── loki/                       # Loki configuration
├── prometheus/                 # Prometheus configuration and rules
│   ├── alerts/                 # Alert rules
│   └── ...
├── promtail/                   # Promtail configuration
├── telegraf/                   # Telegraf configuration
├── docker-compose.yml          # Service definitions
├── .env.example                # Example environment variables
├── setup-config.sh             # Configuration generator script
└── README.md                   # This file
```

### Environment Variables

The `.env` file controls key aspects of the monitoring stack:

- Service ports
- Credentials
- Alerting channels
- Retention settings
- Resource limits

See `.env.example` for all available options.

### Templates

All configuration files use templates (`.yml.template`, `.conf.template`) that are processed during setup:

- Values from the `.env` file are substituted
- Final configuration files are generated
- Changes to templates require running `setup-config.sh` again

## 📊 Dashboards

The stack comes with several pre-configured dashboards:

| Dashboard                  | Description                                     |
| -------------------------- | ----------------------------------------------- |
| **Node Exporter Overview** | Host-level metrics (CPU, memory, disk, network) |
| **Docker Containers**      | Container metrics from cAdvisor                 |
| **Prometheus Stats**       | Prometheus performance and health               |
| **Alertmanager Overview**  | Alert status and history                        |
| **Loki Logs**              | Log exploration and search                      |

To add custom dashboards:

1. Export dashboard JSON from Grafana
2. Place in `grafana/provisioning/dashboards/`
3. Update `grafana/provisioning/dashboards/dashboard.yml` if needed
4. Restart Grafana: `docker-compose restart grafana`

## 🔔 Alerting

### Alert Channels

- **Email**: Configure via SMTP settings in `.env`
- **Slack**: Configure via webhook URL in `.env`
- **Other integrations**: Can be added in `alertmanager/alertmanager.yml.template`

### Alert Rules

- Default rules are in `prometheus/alerts/custom_alerts.yml`
- Add new rules by creating files in `prometheus/alerts/`
- Rules are automatically picked up by Prometheus

Example alert rule:

```yaml
groups:
  - name: host
    rules:
      - alert: HighCpuLoad
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: High CPU load (instance {{ $labels.instance }})
          description: CPU load is > 80%\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}
```

## 🔄 Extending the Stack

### Adding New Services to Monitor

1. Add a new section to `prometheus/prometheus.yml.template`:

```yaml
- job_name: 'new-service'
  static_configs:
    - targets: ['new-service:9090']
```

2. Run `./setup-config.sh` to regenerate configurations
3. Restart Prometheus: `docker-compose restart prometheus`

### Adding Custom Exporters

1. Add the exporter to `docker-compose.yml`:

```yaml
custom-exporter:
  image: custom-exporter:latest
  ports:
    - '9999:9999'
  networks:
    - monitoring
```

2. Add a scrape configuration to `prometheus/prometheus.yml.template`
3. Run `./setup-config.sh`
4. Restart the stack: `docker-compose up -d`

## 🔐 Security Considerations

### Authentication

- Grafana: Protected by username/password (configured in `.env`)
- Basic auth can be enabled for other components by editing their respective config templates

### Network Security

- Default configuration exposes ports to host
- For production, consider:
  - Using a reverse proxy with TLS
  - Implementing network isolation
  - Setting up firewall rules

### Production Recommendations

- Change all default passwords
- Enable TLS for all connections
- Use Docker secrets or Kubernetes secrets for sensitive values
- Implement proper backup for data volumes

## 🔍 Troubleshooting

### Common Issues

- **Loki fails to start**: Ensure schema and index type configuration match (see loki-config.yml)
- **Prometheus can't scrape targets**: Check network connectivity and firewall rules
- **Grafana doesn't show data**: Verify data source configuration and test connection
- **Alerts not sending**: Check SMTP or webhook configuration

### Logs

View logs for any service:

```bash
docker-compose logs -f [service_name]
```

Example:

```bash
docker-compose logs -f prometheus
docker-compose logs -f loki
```

## 📚 Maintenance

### Updating

To update the stack to the latest images:

```bash
docker-compose pull
docker-compose up -d
```

### Backup

Back up configuration and data:

```bash
# Configuration
tar -czvf config-backup.tar.gz */*.yml */*.conf

# Data volumes
docker run --rm -v prometheus_data:/data -v $(pwd):/backup alpine tar -czvf /backup/prometheus-data.tar.gz /data
docker run --rm -v grafana_data:/data -v $(pwd):/backup alpine tar -czvf /backup/grafana-data.tar.gz /data
docker run --rm -v loki_data:/data -v $(pwd):/backup alpine tar -czvf /backup/loki-data.tar.gz /data
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Run the tests (if any)
4. Commit your changes (`git commit -m 'Add some amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📚 Resources

- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Loki Documentation](https://grafana.com/docs/loki/latest/)
- [AlertManager Documentation](https://prometheus.io/docs/alerting/latest/alertmanager/)
- [Node Exporter Documentation](https://prometheus.io/docs/guides/node-exporter/)
- [cAdvisor Documentation](https://github.com/google/cadvisor/blob/master/docs/README.md)
