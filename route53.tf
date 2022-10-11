resource "aws_route53_record" "smalldomains_auth" {
  allow_overwrite = true
  name            = aws_cognito_user_pool_domain.smalldomains.domain
  type            = "A"
  ttl             = 60
  zone_id         = data.aws_ssm_parameter.smalldomains_zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.smalldomains.cloudfront_distribution_arn

    # This zone_id is fixed for all Cognito User Pool instances
    zone_id = "Z2FDTNDATAQYW2"
  }
}