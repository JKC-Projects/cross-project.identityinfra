resource "aws_ses_email_identity" "verifyaccount" {
  email = format("no-reply.verify-account@%s", local.env_root_domain)
}

resource "aws_ses_domain_identity" "smalldomains" {
  domain = local.env_root_domain
}

resource "aws_ses_domain_dkim" "smalldomains" {
  domain = aws_ses_domain_identity.smalldomains.domain
}

resource "aws_ses_domain_identity_verification" "smalldomains" {
  domain     = aws_ses_domain_identity.smalldomains.id
  depends_on = [aws_route53_record.emaildomain_verification]
}