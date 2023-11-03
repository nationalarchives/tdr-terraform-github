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
  github_access_token_name = "/mgmt/github/access_token"
  akka_licence_token_name  = "/mgmt/akka/licence_token"
  environment              = terraform.workspace
  region                   = "eu-west-2"
  account_id               = module.configuration.account_numbers[local.environment]
  apply_repository         = local.environment == "mgmt" ? 1 : 0
  apply_environment        = local.environment != "mgmt" ? 1 : 0
  mgmt_apply_environment   = local.environment == "mgmt" ? 1 : 0
  workflow_pat_parameter = {
    name = local.github_access_token_name, description = "The GitHub workflow token", value = "to_be_manually_added",
    type = "SecureString", tier = "Advanced"
  }
  akka_licence_token_parameter = {
    name = local.akka_licence_token_name, description = "Licence token for Akka", value = "to_be_manually_added",
    type = "SecureString"
  }
  common_parameters_repository  = [local.workflow_pat_parameter, local.akka_licence_token_parameter]
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
    bucket         = "tdr-terraform-state-github"
    key            = "terraform.state"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "tdr-terraform-github-state-lock"
  }
}

module "github_oidc_provider" {
  source          = "./da-terraform-modules/openid_provider"
  audience        = "sts.amazonaws.com"
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
  url             = "https://token.actions.githubusercontent.com"
  tags            = local.common_tags
}

module "github_actions_deploy_lambda_policy" {
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGithubActionsDeployLambda${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/deploy_lambda_github_actions.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, environment = local.environment, region = local.region
  })
}

module "github_actions_role" {
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-*"
  })
  tags = local.common_tags
  name = "TDRGithubActionsDeployLambda${title(local.environment)}"
  policy_attachments = {
    deploy_lambda = module.github_actions_deploy_lambda_policy.policy_arn
  }
}

module "github_run_e2e_tests_policy" {
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGithubActionsRunE2ETestsPolicy${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_run_e2e_tests_policy.json.tpl", {
    environment = local.environment
  })
}

module "github_run_e2e_tests_role" {
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
  })
  tags = local.common_tags
  name = "TDRGithubActionsRunE2ETestsRole${title(local.environment)}"
  policy_attachments = {
    run_tests_policy = module.github_run_e2e_tests_policy.policy_arn
  }
}

module "github_update_ecs_policy" {
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGitHubECSUpdatePolicy${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_update_ecs_policy.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, region = local.region, environment = local.environment
  })
}

module "github_update_ecs_role" {
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-"
  })
  tags = local.common_tags
  name = "TDRGitHubECSUpdateRole${title(local.environment)}"
  policy_attachments = {
    update_ecs_policy = module.github_update_ecs_policy.policy_arn
  }
}

module "github_get_e2e_secrets_policy" {
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGithubActionsE2ESecretsPolicy${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_e2e_test_secrets_policy.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, environment = local.environment
  })
}

module "github_get_e2e_tests_secrets" {
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-"
  })
  tags = local.common_tags
  name = "TDRGithubActionsGetE2ESecretsRole${title(local.environment)}"
  policy_attachments = {
    get_ssm_policy = module.github_get_e2e_secrets_policy.policy_arn
  }
}

module "github_create_db_user_policy" {
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGithubActionsInvokeCreateUserLambdaPolicy${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_invoke_create_user_lambda_policy.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, environment = local.environment
  })
}

module "github_create_db_user_role" {
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
  })
  tags               = local.common_tags
  name               = "TDRGithubActionsInvokeCreateUserLambdaRole${title(local.environment)}"
  policy_attachments = { create_user_policy = module.github_create_db_user_policy.policy_arn }
}

module "github_file_format_run_ecs_role" {
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-*"
  })
  tags = local.common_tags
  name = "TDRGithubActionsRunFileFormatECS${title(local.environment)}"
  policy_attachments = {
    run_file_format = module.github_run_file_format_build_policy.policy_arn
  }
}

module "github_run_file_format_build_policy" {
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGitHubRunFileFormatBuildPolicy${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_run_ecs_policy.json.tpl",
    {
      task_definition_arn = "arn:aws:ecs:${local.region}:${data.aws_caller_identity.current.account_id}:task-definition/file-format-build-${local.environment}",
      cluster_arn         = "arn:aws:ecs:${local.region}:${data.aws_caller_identity.current.account_id}:cluster/file_format_build_${local.environment}",
      role_arns           = "\"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TDRFileFormatEcsTaskRole${title(local.environment)}\", \"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TDRFileFormatECSExecutionRole${title(local.environment)}\""
  })
}
