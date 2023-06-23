locals {
  github_state_lock   = "tdr-terraform-github-state-lock"
  github_state_bucket = "tdr_terraform_github_state"
  common_tags = tomap(
    {
      "Owner"           = "TDR Github",
      "Terraform"       = true,
      "TerraformSource" = "https://github.com/nationalarchives/tdr-terraform-github",
      "CostCentre"      = data.aws_ssm_parameter.cost_centre.value
    }
  )
  github_access_token_name = "/mgmt/github/access_token"
}

module "common_ssm_parameters" {
  source      = "./da-terraform-modules/ssm_parameter"
  common_tags = local.common_tags
  random_parameters = [
    {
      name = local.github_access_token_name, description = "The GitHub workflow token", value = "to_be_manually_added", type = "SecureString", tier = "Advanced"
    }
  ]
}

module "global_parameters" {
  source = "./tdr-configurations/terraform"
}

terraform {
  backend "s3" {
    bucket         = local.github_state_bucket
    key            = "terraform.state"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = local.github_state_lock
  }
}
#
#//Set up Terraform Backend state
#module "terraform_state" {
#  source = "./modules/state"
#
#  common_tags = local.common_tags
#}
#
#//Set up Terraform Backend statelock
#module "terraform_state_lock" {
#  source = "./modules/state-lock"
#
#  common_tags = local.common_tags
#}
