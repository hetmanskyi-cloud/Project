# --- Internet Monitor Output --- #

# Output the Internet Monitor ID, available only when monitoring is enabled
output "internet_monitor_id" {
  description = "The ID of the Internet Monitor instance if monitoring is enabled" # Outputs monitor ID for external reference
  value       = var.enable_internet_monitor ? aws_internetmonitor_monitor.network_monitor[0].id : null
}
