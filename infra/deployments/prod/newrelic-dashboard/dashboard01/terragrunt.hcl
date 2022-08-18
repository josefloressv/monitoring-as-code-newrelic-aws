# deployments/prod/newrelic-dashboard/dashboard01/terragrunt.hcl

include "root" {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

inputs = {

  # General  
  base_tags = local.common_vars.base_tags

  # NR Dashboard
  dashboard_name        = "app01-dashboard"
  dashboard_description = "Dashboard for app01"
  dashboard_permissions = "public_read_write"
  dashboard_resources = [
    # Page #1
    {
      page_name        = "General"
      page_description = "Page description"
      widgets = [
        # row
        {
          type       = "billboard"
          title      = "Web Transactions"
          num_row    = 1
          num_column = 1
          height     = 4
          width      = 3
          queries = [
            {
              query            = "FROM Transaction SELECT count(*) as 'Total transactions', average(duration) as 'Avg duration (s)', percentile(duration, 90) as 'Slowest 10% (s)', percentage(count(*), WHERE error is false) AS 'Success rate' SINCE 1 WEEK AGO"
              query_account_id = 3588847
            }
          ]
        },
        {
          type       = "stacked_bar"
          title      = "Events"
          num_row    = 1
          num_column = 4
          height     = 4
          width      = 9
          queries = [
            {
              query            = "SELECT average(apm.service.overview.web) * 1000 FROM Metric WHERE (appName='app01') FACET `segmentName` LIMIT MAX SINCE 3600 seconds AGO TIMESERIES "
              query_account_id = 3588847
            }
          ]
        },        
        # row
        {
          type       = "table"
          title      = "Logs"
          num_row    = 2
          num_column = 1
          height     = 4
          width      = 12
          queries = [
            {
              query            = "SELECT * FROM Log"
              query_account_id = 3588847
            }
          ]
        }
      ]
    }
  ]

}
