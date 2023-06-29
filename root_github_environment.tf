module "github_reporting_environment" {
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-reporting"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = data.aws_caller_identity.current.account_id
  }
}
