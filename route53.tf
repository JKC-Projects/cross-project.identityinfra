resource "aws_route53_record" "johnchung_auth" {
  allow_overwrite = true
  name            = aws_cognito_user_pool_domain.johnchung_auth.domain
  type            = "A"
  zone_id         = data.aws_ssm_parameter.john-chung_zone_id.value

  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.johnchung_auth.cloudfront_distribution_arn

    # This zone_id is fixed for all Cognito User Pool instances
    zone_id = "Z2FDTNDATAQYW2"
  }
}