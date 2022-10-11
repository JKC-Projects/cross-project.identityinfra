data "aws_ssm_parameter" "smalldomains_zone_id" {
  name = "/route53/${local.env_root_domain}/zone-id"
}

data "aws_ssm_parameter" "smalldomains_apex_domain" {
  name = "/route53/${local.env_root_domain}/apex-domain"
}