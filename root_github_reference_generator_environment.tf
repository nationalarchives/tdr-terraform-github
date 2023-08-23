# Reference generator repo configuration in separate tf file as Tdr is only hosting this

module "github_da_reference_generator_environment" {
  count                 = local.apply_environment
  source                = "./da-terraform-modules/github_environment_secrets"
  environment           = local.environment
  repository_name       = "nationalarchives/da-reference-generator"
  team_slug             = "transfer-digital-records-admins"
  integration_team_slug = ["transfer-digital-records"]
  secrets = {
    TDR_ACCOUNT_NUMBER = local.account_id
  }
}
