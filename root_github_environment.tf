module "github_keycloak_user_management_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-keycloak-user-management"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    TITLE_STAGE    = title(local.environment)
    ACCOUNT_NUMBER = data.aws_caller_identity.current.account_id
  }
}

module "github_reporting_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-reporting"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = data.aws_caller_identity.current.account_id
  }
}
