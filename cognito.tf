resource "aws_cognito_user_pool" "john-chung" {
  name = "john-chung-cross-project--users"

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
    email_subject         = "Account Verification with SmallDomains"
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
    email_sending_account = "DEVELOPER"
    source_arn            = aws_ses_domain_identity.smalldomains.arn
    from_email_address    = "\"No Reply - Small Domains\" <noreply@${var.environment == "prod" ? "" : "${var.environment}."}small.domains>"
  }
}

resource "aws_cognito_user_pool_client" "smalldomains" {
  name                                 = "small-domains--web-app"
  user_pool_id                         = aws_cognito_user_pool.john-chung.id
  callback_urls                        = var.environment == "prod" ? ["https://pages.small.domains"] : ["https://pages.dev.small.domains", "http://localhost:3000"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid"]
  supported_identity_providers         = ["COGNITO"]
  prevent_user_existence_errors        = "ENABLED"
}

resource "aws_cognito_user_pool_domain" "smalldomains" {
  domain          = local.fqdn
  certificate_arn = module.auth.tls_cert.arn
  user_pool_id    = aws_cognito_user_pool.john-chung.id
}