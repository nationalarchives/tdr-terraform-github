data "aws_caller_identity" "current" {}

module "github_oidc_provider" {
  source          = "../../da-terraform-modules/openid_provider"
  audience        = "sts.amazonaws.com"
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
  url             = "https://token.actions.githubusercontent.com"
  tags            = var.common_tags
}

module "github_actions_deploy_lambda_policy" {
  source        = "../../da-terraform-modules/iam_policy"
  name          = "TDRGithubActionsDeployLambda${title(var.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/deploy_lambda_github_actions.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, environment = var.environment, region = var.region
  })
}

module "github_actions_role" {
  source             = "../../da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-*"
  })
  tags               = var.common_tags
  name               = "TDRGithubActionsDeployLambda${title(var.environment)}"
  policy_attachments = {
    deploy_lambda = module.github_actions_deploy_lambda_policy.policy_arn
  }
}

module "github_run_e2e_tests_policy" {
  source        = "../../da-terraform-modules/iam_policy"
  name          = "TDRGithubActionsRunE2ETestsPolicy${title(var.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_run_e2e_tests_policy.json.tpl", {
    environment = var.environment
  })
}

module "github_run_e2e_tests_role" {
  source             = "../../da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
  })
  tags               = var.common_tags
  name               = "TDRGithubActionsRunE2ETestsRole${title(var.environment)}"
  policy_attachments = {
    run_tests_policy = module.github_run_e2e_tests_policy.policy_arn
  }
}

module "github_update_ecs_policy" {
  source        = "../../da-terraform-modules/iam_policy"
  name          = "TDRGitHubECSUpdatePolicy${title(var.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_update_ecs_policy.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, region = var.region, environment = var.environment
  })
}

module "github_update_ecs_role" {
  source             = "../../da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-"
  })
  tags               = var.common_tags
  name               = "TDRGitHubECSUpdateRole${title(var.environment)}"
  policy_attachments = {
    update_ecs_policy = module.github_update_ecs_policy.policy_arn
  }
}

module "github_get_e2e_secrets_policy" {
  source        = "../../da-terraform-modules/iam_policy"
  name          = "TDRGithubActionsE2ESecretsPolicy${title(var.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_e2e_test_secrets_policy.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, environment = var.environment
  })
}

module "github_get_e2e_tests_secrets" {
  source             = "../../da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-"
  })
  tags               = var.common_tags
  name               = "TDRGithubActionsGetE2ESecretsRole${title(var.environment)}"
  policy_attachments = {
    get_ssm_policy = module.github_get_e2e_secrets_policy.policy_arn
  }
}

module "github_create_db_user_policy" {
  source        = "../../da-terraform-modules/iam_policy"
  name          = "TDRGithubActionsInvokeCreateUserLambdaPolicy${title(var.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_invoke_create_user_lambda_policy.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, environment = var.environment
  })
}

module "github_create_db_user_role" {
  source             = "../../da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
  })
  tags               = var.common_tags
  name               = "TDRGithubActionsInvokeCreateUserLambdaRole${title(var.environment)}"
  policy_attachments = { create_user_policy = module.github_create_db_user_policy.policy_arn }
}

module "github_run_file_format_build_policy" {
  source        = "../../da-terraform-modules/iam_policy"
  name          = "TDRGitHubRunFileFormatBuildPolicy${title(var.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_run_ecs_policy.json.tpl",
    {
      task_definition_arn = "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task-definition/file-format-build-${var.environment}",
      cluster_arn         = "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/file_format_build_${var.environment}",
      role_arns           = "\"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TDRFileFormatEcsTaskRole${title(var.environment)}\", \"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TDRFileFormatECSExecutionRole${title(var.environment)}\""
    })
}

module "github_file_format_run_ecs_role" {
  source             = "../../da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-*"
  })
  tags               = var.common_tags
  name               = "TDRGithubActionsRunFileFormatECS${title(var.environment)}"
  policy_attachments = {
    run_file_format = module.github_run_file_format_build_policy.policy_arn
  }
}
