locals {
  env_root_domain = format("%ssmall.domains", var.environment == "prod" ? "" : "${var.environment}.")
  fqdn            = format("auth.%s", local.env_root_domain)

  default_tags = {
    project     = "smalldomains"
    managed_by  = "terraform"
    github_repo = "smalldomains.identityinfra"
  }
}