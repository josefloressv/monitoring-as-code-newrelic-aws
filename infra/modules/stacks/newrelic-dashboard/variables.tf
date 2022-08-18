variable "dashboard_name" {
  type        = string
  description = "The title of the Dashboard."
}

variable "dashboard_description" {
  type        = string
  description = "Brief text describing the dashboard."
  default     = ""
}

variable "dashboard_permissions" {
  type        = string
  description = "Determines who can see the dashboard in an account. Valid values are [private, public_read_only, public_read_write] default to public_read_only"
  default     = "public_read_only"
}

variable "dashboard_resources" {
  description = "Resources for dynamic dashboards"
  type = list(object({
    page_name        = string
    page_description = optional(string)
    widgets = list(object({
      type       = string
      title      = string
      num_row    = number
      num_column = number
      width      = number
      height     = number
      queries = optional(list(object({
        query            = string
        query_account_id = number # Source account to fetch data from.
      })))
      markdown_text = optional(string)
    }))
  }))
}