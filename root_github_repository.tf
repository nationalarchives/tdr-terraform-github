module "configuration" {
  source  = "./da-terraform-configurations"
  project = "tdr"
}

locals {
  account_secrets = {
    for environment, _ in module.configuration.account_numbers : environment => {
      "TDR_${upper(environment)}_ACCOUNT_NUMBER"        = module.configuration.account_numbers[environment]
      "TDR_${upper(environment)}_TERRAFORM_ROLE"        = module.configuration.terraform_config[environment]["terraform_role"]
      "TDR_${upper(environment)}_CUSTODIAN_ROLE"        = module.configuration.terraform_config[environment]["custodian_role"]
      "TDR_${upper(environment)}_STATE_BUCKET"          = module.configuration.terraform_config[environment]["state_bucket"]
      "TDR_${upper(environment)}_DYNAMO_TABLE"          = module.configuration.terraform_config[environment]["dynamo_table"]
      "TDR_${upper(environment)}_TERRAFORM_EXTERNAL_ID" = module.configuration.terraform_config[environment]["terraform_external_id"]
    }
  }
  #  workflow_pat_parameter = { name = local.github_access_token_name, description = "The GitHub workflow token", value = "to_be_manually_added", type = "SecureString", tier = "Advanced" }
  #  common_parameters = local.apply_repository_secrets == 1 ? [local.workflow_pat_parameter] : []
}

#module "common_ssm_parameters" {
#  source = "./da-terraform-modules/ssm_parameter"
#  tags   = local.common_tags
#  parameters = local.common_parameters
#}

module "github_keycloak_user_management_repository" {
  count           = local.apply_repository_secrets
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-keycloak-user-management"
  secrets = {
    MANAGEMENT_ACCOUNT     = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_FAILURE_WORKFLOW = data.aws_ssm_parameter.slack_failure_workflow.value
    SLACK_SUCCESS_WORKFLOW = data.aws_ssm_parameter.slack_success_workflow.value
    WORKFLOW_PAT           = module.common_ssm_parameters.params[local.github_access_token_name].value
  }
}

module "github_reporting_repository" {
  count           = local.apply_repository_secrets
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-reporting"
  collaborators   = module.global_parameters.collaborators
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = module.common_ssm_parameters.params[local.github_access_token_name].value
  }
}
