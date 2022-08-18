output "nr_dashboard_url" {
  description = "Permalink to the New Relic Dashboard"
  value = newrelic_one_dashboard.nrdashboard.permalink
}