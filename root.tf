module "configuration" {
  source  = "./da-terraform-configurations"
  project = "tdr"
}

locals {
  github_state_lock   = "tdr-terraform-github-state-lock"
  github_state_bucket = "tdr-terraform-state-github"
  common_tags = tomap(
    {
      "Environment"     = local.environment,
      "Owner"           = "TDR Github",
      "Terraform"       = true,
      "TerraformSource" = "https://github.com/nationalarchives/tdr-terraform-github",
      "CostCentre"      = data.aws_ssm_parameter.cost_centre.value
    }
  )
  region                        = "eu-west-2"
  github_access_token_name      = "/mgmt/github/access_token"
  environment                   = terraform.workspace
  account_id                    = module.configuration.account_numbers[local.environment]
  apply_repository              = local.environment == "mgmt" ? 1 : 0
  apply_environment             = local.environment != "mgmt" ? 1 : 0
  mgmt_apply_environment        = local.environment == "mgmt" ? 1 : 0
  workflow_pat_parameter        = { name = local.github_access_token_name, description = "The GitHub workflow token", value = "to_be_manually_added", type = "SecureString", tier = "Advanced" }
  common_parameters_repository  = [local.workflow_pat_parameter]
  common_parameters_environment = []
  common_parameters             = local.apply_repository == 1 ? local.common_parameters_repository : local.common_parameters_environment
}

module "github_oidc_provider" {
  source      = "./da-terraform-modules/openid_provider"
  audience    = "sts.amazonaws.com"
  url         = "https://token.actions.githubusercontent.com"
  tags        = local.common_tags
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}

module "common_ssm_parameters" {
  source     = "./da-terraform-modules/ssm_parameter"
  tags       = local.common_tags
  parameters = local.common_parameters
}

module "global_parameters" {
  source = "./tdr-configurations/terraform"
}

terraform {
  backend "s3" {
    bucket         = "tdr-terraform-state-github"
    key            = "terraform.state"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "tdr-terraform-github-state-lock"
  }
}
