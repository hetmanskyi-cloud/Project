# --- Internet Monitor Output --- #

# Output the Internet Monitor ID for external reference if monitoring is enabled
output "internet_monitor_id" {
  description = "The ID of the Internet Monitor instance if enabled"                                   # Provides the monitor ID when enabled
  value       = var.enable_internet_monitor ? aws_internetmonitor_monitor.network_monitor[0].id : null # Conditionally outputs the Internet Monitor ID
}
