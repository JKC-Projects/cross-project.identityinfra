locals {
  userpool_name   = "cross-project--users"
  env_root_domain = format("%sjohn-chung.dev", var.environment == "prod" ? "" : "${var.environment}.")
  fqdn            = format("auth.%s", local.env_root_domain)

  user_pool_clients_auth_only = [for c in
    [
      {
        project       = "small-domains"
        application   = "web-app"
        callback_urls = var.environment == "prod" ? ["https://pages.small.domains/auth/JwtTokens"] : ["https://pages.dev.small.domains/auth/JwtTokens", "http://localhost:3000/auth/JwtTokens"]
      }
    ] :
    {
      client_name   = "${c.project}--${c.application}"
      callback_urls = c.callback_urls
      project       = c.project
      application   = c.application
    }
  ]

  default_tags = {
    project     = "cross-project"
    managed_by  = "terraform"
    github_repo = "cross-project.identityinfra"
  }
}