resource "aws_cognito_user_pool" "john-chung" {
  name = local.userpool_name

  username_configuration {
    case_sensitive = true
  }

  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]

  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "email"
    required            = true
    string_attribute_constraints {
      min_length = 1
      max_length = 64
    }
  }

  password_policy {
    minimum_length    = 12
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  verification_message_template {
    default_email_option  = "CONFIRM_WITH_LINK"
    email_subject         = "Account Verification"
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

resource "aws_cognito_user_pool_client" "auth_only" {
  for_each                             = { for c in local.user_pool_clients_auth_only : c.client_name => c }
  name                                 = each.value.client_name
  user_pool_id                         = aws_cognito_user_pool.john-chung.id
  callback_urls                        = each.value.callback_urls
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid"]
  supported_identity_providers         = ["COGNITO"]
  prevent_user_existence_errors        = "ENABLED"

  explicit_auth_flows     = ["ALLOW_REFRESH_TOKEN_AUTH"]
  access_token_validity   = 5
  id_token_validity       = 5
  refresh_token_validity  = 120
  enable_token_revocation = true

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "minutes"
  }
}

resource "aws_cognito_user_pool_domain" "johnchung_auth" {
  domain          = local.fqdn
  certificate_arn = module.auth.tls_cert.arn
  user_pool_id    = aws_cognito_user_pool.john-chung.id
}