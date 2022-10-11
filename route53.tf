resource "aws_route53_record" "smalldomains_auth" {
  allow_overwrite = true
  name            = local.fqdn
  type            = "A"
  zone_id         = data.aws_ssm_parameter.smalldomains_zone_id.value

  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.smalldomains.cloudfront_distribution_arn

    # This zone_id is fixed for all Cognito User Pool instances
    zone_id = "Z2FDTNDATAQYW2"
  }
}

resource "aws_route53_record" "emaildomain_verification" {
  zone_id         = data.aws_ssm_parameter.smalldomains_zone_id.value
  allow_overwrite = true

  name    = "_amazonses.${aws_ses_domain_identity.smalldomains.id}"
  type    = "TXT"
  records = [aws_ses_domain_identity.smalldomains.verification_token]
}