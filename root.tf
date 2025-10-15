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
  github_access_token_name              = "/mgmt/github/access_token"
  github_enterprise_access_token_name   = "/mgmt/github_enterprise/access_token"
  github_enterprise_gpg_passphrase_name = "/mgmt/github_enterprise/gpg/passphrase"
  github_enterprise_private_key_name    = "/mgmt/github_enterprise/gpg/private_key"
  github_enterprise_public_key_name     = "/mgmt/github_enterprise/gpg/public_key"
  github_enterprise_key_id_name         = "/mgmt/github_enterprise/gpg/key_id"
  akka_licence_token_name               = "/mgmt/akka/licence_token"
  npm_granular_token_name               = "/mgmt/npm_granular_token"
  environment                           = terraform.workspace
  region                                = "eu-west-2"
  account_id                            = module.configuration.account_numbers[local.environment]
  intg_account_id                       = module.configuration.account_numbers[local.intg_environment]
  intg_environment                      = "intg"
  internal_buckets_kms_key_alias        = module.configuration.terraform_config[local.environment]["internal_buckets_kms_key_alias"]
  staging_account_id                    = module.configuration.account_numbers[local.staging_environment]
  staging_environment                   = "staging"
  prod_account_id                       = module.configuration.account_numbers[local.prod_environment]
  prod_environment                      = "prod"
  apply_repository                      = local.environment == "mgmt" ? 1 : 0
  apply_environment                     = local.environment != "mgmt" ? 1 : 0
  mgmt_apply_environment                = local.environment == "mgmt" ? 1 : 0
  intg_apply                            = local.environment == "intg" ? 1 : 0
  staging_apply                         = local.environment == "staging" ? 1 : 0
  prod_apply                            = local.environment == "prod" ? 1 : 0
  workflow_enterprise_pat_parameter = {
    name = local.github_enterprise_access_token_name, description = "The GitHub Enterprise workflow token", value = "to_be_manually_added",
    type = "SecureString", tier = "Advanced"
  }
  npm_granular_token_parameter = {
    name = local.npm_granular_token_name, description = "NPM granular token", value = "to_be_manually_added",
    type = "SecureString", tier = "Advanced"
  }
  akka_licence_token_parameter = {
    name = local.akka_licence_token_name, description = "Licence token for Akka", value = "to_be_manually_added",
    type = "SecureString"
  }
  github_enterprise_gpg_passphrase_parameter = {
    name = local.github_enterprise_gpg_passphrase_name, description = "GitHub Enterprise GPG passphase for key", value = "to_be_manually_added",
    type = "SecureString"
  }
  github_enterprise_private_key_parameter = {
    name = local.github_enterprise_private_key_name, description = "GitHub Enterprise GPG private key", value = "to_be_manually_added",
    type = "SecureString"
  }
  github_enterprise_public_key_parameter = {
    name = local.github_enterprise_public_key_name, description = "GitHub Enterprise GPG public key", value = "to_be_manually_added",
    type = "SecureString"
  }
  github_enterprise_key_id_parameter = {
    name = local.github_enterprise_key_id_name, description = "GitHub Enterprise GPG key id", value = "to_be_manually_added",
    type = "SecureString"
  }
  common_parameters_repository = [
    local.akka_licence_token_parameter, local.workflow_enterprise_pat_parameter, local.npm_granular_token_parameter, local.github_enterprise_gpg_passphrase_parameter,
    local.github_enterprise_key_id_parameter, local.github_enterprise_private_key_parameter, local.github_enterprise_public_key_parameter
  ]
  common_parameters_environment = []
  common_parameters             = local.apply_repository == 1 ? local.common_parameters_repository : local.common_parameters_environment
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
    bucket       = "tdr-terraform-state-github"
    key          = "terraform.state"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
