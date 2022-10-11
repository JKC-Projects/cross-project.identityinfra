resource "aws_ses_email_identity" "verifyaccount" {
  email = format("verify-account@%s", local.env_root_domain)
}

resource "aws_ses_domain_identity" "smalldomains" {
  domain = local.env_root_domain
}

resource "aws_ses_domain_identity_verification" "example_verification" {
  domain     = aws_ses_domain_identity.example.id
  depends_on = [aws_route53_record.emaildomain_verification]
}