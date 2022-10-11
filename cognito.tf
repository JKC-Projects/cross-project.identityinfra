resource "aws_cognito_user_pool" "smalldomains" {
  name = "smalldomains-users"

  username_configuration {
    case_sensitive = true
  }

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 12
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  verification_message_template {
    default_email_option  = "CONFIRM_WITH_LINK"
    email_subject         = "Verify your Account with SmallDomains"
    email_message_by_link = "To verify your account, {##click here##}"
  }

  mfa_configuration = "OPTIONAL"

  software_token_mfa_configuration {
    enabled = true
  }

  device_configuration {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
}

resource "aws_cognito_user_pool_client" "smalldomains" {
  name                                 = "web-app"
  user_pool_id                         = aws_cognito_user_pool.smalldomains.id
  callback_urls                        = var.environment == "prod" ? ["https://pages.small.domains"] : ["http://localhost:3000", "https://pages.dev.small.domains"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "smalldomains" {
  domain          = local.fqdn
  certificate_arn = module.auth.tls_cert.arn
  user_pool_id    = aws_cognito_user_pool.smalldomains.id
}