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
  github_access_token_name = "/mgmt/github/access_token"
  environment              = terraform.workspace
  apply_repository_secrets = local.environment == "mgmt" ? 1 : 0
  workflow_pat_parameter   = { name = local.github_access_token_name, description = "The GitHub workflow token", value = "to_be_manually_added", type = "SecureString", tier = "Advanced" }
  common_parameters        = local.apply_repository_secrets == 1 ? [local.workflow_pat_parameter] : []
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
