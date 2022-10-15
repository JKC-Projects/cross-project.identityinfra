resource "aws_ssm_parameter" "client_ids_auth_only" {
  for_each    = { for c in local.user_pool_clients_auth_only : c.name => c }
  name        = "/cognito/${local.userpool_name}/${each.value.project}/${each.value.application}/client-id"
  type        = "String"
  value       = aws_cognito_user_pool_client.auth_only[each.value.client_name].id
  description = "The OAuth2.0 Client ID for ${each.value.project}/${each.value.application} as per the ${aws_cognito_user_pool.john-chung.name} Cognito User Pool"
}