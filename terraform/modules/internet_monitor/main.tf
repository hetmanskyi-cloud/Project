# --- Internet Monitor Configuration for VPC Monitoring --- #

# Configure the Internet Monitor for VPC monitoring to observe traffic patterns and performance
resource "aws_internetmonitor_monitor" "network_monitor" {
  count                         = var.enable_internet_monitor ? 1 : 0   # Conditional creation based on enable variable
  monitor_name                  = "${var.name_prefix}-internet-monitor" # Dynamic monitor name with prefix
  traffic_percentage_to_monitor = var.traffic_percentage                # Specify the percentage of VPC traffic to monitor

  # Tags for resource identification and management
  tags = {
    Name        = "${var.name_prefix}-internet-monitor" # Resource tag with dynamic name
    Environment = var.environment                       # Environment tag for categorization
  }
}
