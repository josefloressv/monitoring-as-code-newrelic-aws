resource "newrelic_one_dashboard" "nrdashboard" {
  name        = var.dashboard_name
  description = var.dashboard_description
  permissions = var.dashboard_permissions

  dynamic "page" {
    for_each = var.dashboard_resources
    content {
      name        = page.value.page_name
      description = page.value.page_description

      dynamic "widget_area" {
        for_each = [
          for widget in page.value.widgets : widget
          if widget.type == "area"
        ]
        content {
          title  = widget_area.value.title
          row    = widget_area.value.num_row
          column = widget_area.value.num_column
          width  = widget_area.value.width
          height = widget_area.value.height

          dynamic "nrql_query" {
            for_each = widget_area.value.queries
            content {
              query      = nrql_query.value.query
              account_id = nrql_query.value.query_account_id
            }
          }
        }
      }

      dynamic "widget_line" {
        for_each = [
          for widget in page.value.widgets : widget
          if widget.type == "line"
        ]
        content {
          title  = widget_line.value.title
          row    = widget_line.value.num_row
          column = widget_line.value.num_column
          width  = widget_line.value.width
          height = widget_line.value.height

          dynamic "nrql_query" {
            for_each = widget_line.value.queries
            content {
              query      = nrql_query.value.query
              account_id = nrql_query.value.query_account_id
            }
          }
        }
      }

      dynamic "widget_table" {
        for_each = [
          for widget in page.value.widgets : widget
          if widget.type == "table"
        ]
        content {
          title  = widget_table.value.title
          row    = widget_table.value.num_row
          column = widget_table.value.num_column
          width  = widget_table.value.width
          height = widget_table.value.height

          dynamic "nrql_query" {
            for_each = widget_table.value.queries
            content {
              query      = nrql_query.value.query
              account_id = nrql_query.value.query_account_id
            }
          }
        }
      }

      dynamic "widget_bar" {
        for_each = [
          for widget in page.value.widgets : widget
          if widget.type == "bar"
        ]
        content {
          title  = widget_bar.value.title
          row    = widget_bar.value.num_row
          column = widget_bar.value.num_column
          width  = widget_bar.value.width
          height = widget_bar.value.height

          dynamic "nrql_query" {
            for_each = widget_bar.value.queries
            content {
              query      = nrql_query.value.query
              account_id = nrql_query.value.query_account_id
            }
          }
        }
      }

      dynamic "widget_stacked_bar" {
        for_each = [
          for widget in page.value.widgets : widget
          if widget.type == "stacked_bar"
        ]
        content {
          title  = widget_stacked_bar.value.title
          row    = widget_stacked_bar.value.num_row
          column = widget_stacked_bar.value.num_column
          width  = widget_stacked_bar.value.width
          height = widget_stacked_bar.value.height

          dynamic "nrql_query" {
            for_each = widget_stacked_bar.value.queries
            content {
              query      = nrql_query.value.query
              account_id = nrql_query.value.query_account_id
            }
          }
        }
      }

      dynamic "widget_pie" {
        for_each = [
          for widget in page.value.widgets : widget
          if widget.type == "pie"
        ]
        content {
          title  = widget_pie.value.title
          row    = widget_pie.value.num_row
          column = widget_pie.value.num_column
          width  = widget_pie.value.width
          height = widget_pie.value.height

          dynamic "nrql_query" {
            for_each = widget_pie.value.queries
            content {
              query      = nrql_query.value.query
              account_id = nrql_query.value.query_account_id
            }
          }
        }
      }

      dynamic "widget_histogram" {
        for_each = [
          for widget in page.value.widgets : widget
          if widget.type == "histogram"
        ]
        content {
          title  = widget_histogram.value.title
          row    = widget_histogram.value.num_row
          column = widget_histogram.value.num_column
          width  = widget_histogram.value.width
          height = widget_histogram.value.height

          dynamic "nrql_query" {
            for_each = widget_histogram.value.queries
            content {
              query      = nrql_query.value.query
              account_id = nrql_query.value.query_account_id
            }
          }
        }
      }

      dynamic "widget_billboard" {
        for_each = [
          for widget in page.value.widgets : widget
          if widget.type == "billboard"
        ]
        content {
          title  = widget_billboard.value.title
          row    = widget_billboard.value.num_row
          column = widget_billboard.value.num_column
          width  = widget_billboard.value.width
          height = widget_billboard.value.height

          dynamic "nrql_query" {
            for_each = widget_billboard.value.queries
            content {
              query      = nrql_query.value.query
              account_id = nrql_query.value.query_account_id
            }
          }
        }
      }

      dynamic "widget_markdown" {
        for_each = [
          for widget in page.value.widgets : widget
          if widget.type == "markdown"
        ]
        content {
          title  = widget_markdown.value.title
          row    = widget_markdown.value.num_row
          column = widget_markdown.value.num_column
          width  = widget_markdown.value.width
          height = widget_markdown.value.height

          text = widget_markdown.value.markdown_text
        }
      }

    }
  }
}