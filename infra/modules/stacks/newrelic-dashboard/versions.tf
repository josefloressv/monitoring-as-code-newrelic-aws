terraform {
  required_version = "~> 1.2.0"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.49.0"
    }
  }

  backend "s3" {}

  experiments = [module_variable_optional_attrs]
}

# Configure the New Relic Provider
provider "newrelic" {
  #    account_id = NEW_RELIC_ACCOUNT_ID
  #    api_key = NEW_RELIC_API_KEY
  region = "US"
}
