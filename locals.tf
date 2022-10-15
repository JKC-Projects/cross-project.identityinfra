locals {
  env_root_domain = format("%sjohn-chung.dev", var.environment == "prod" ? "" : "${var.environment}.")
  fqdn            = format("authentication.%s", local.env_root_domain)

  default_tags = {
    project     = "cross-project"
    managed_by  = "terraform"
    github_repo = "cross-project.identityinfra"
  }
}