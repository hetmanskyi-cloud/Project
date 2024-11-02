# --- Internet Monitor Configuration for VPC Monitoring --- #

# Set up Internet Monitor to observe traffic patterns and network performance
resource "aws_internetmonitor_monitor" "network_monitor" {
  count                         = var.enable_internet_monitor ? 1 : 0   # Create monitor only if enabled
  monitor_name                  = "${var.name_prefix}-internet-monitor" # Dynamic name for Internet Monitor instance
  traffic_percentage_to_monitor = var.traffic_percentage                # Specify percentage of traffic to monitor

  # Tags for resource management and identification
  tags = {
    Name        = "${var.name_prefix}-internet-monitor" # Resource tag with dynamic name
    Environment = var.environment                       # Tag indicating deployment environment
  }
}
