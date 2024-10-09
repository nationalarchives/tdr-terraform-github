# Reference generator repo configuration in separate tf file as Tdr is only hosting this

module "github_da_reference_generator_repository_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/da-reference-generator"
  secrets = {
    "TDR_${upper(local.environment)}_ACCOUNT_NUMBER" = local.account_id
  }
}

module "github_da_reference_generator_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/da-reference-generator"
  secrets = {
    TDR_MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    TDR_SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    TDR_WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}
