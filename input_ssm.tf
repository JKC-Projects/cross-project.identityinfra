data "aws_ssm_parameter" "john-chung_zone_id" {
  name = "/route53/${local.env_root_domain}/zone-id"
}

data "aws_ssm_parameter" "john-chung_apex_domain" {
  name = "/route53/${local.env_root_domain}/apex-domain"
}