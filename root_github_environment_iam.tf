module "github_oidc_provider" {
  count       = local.apply_environment
  source      = "./da-terraform-modules/openid_provider"
  audience    = "sts.amazonaws.com"
  thumbprint  = "6938fd4d98bab03faadb97b34396831e3780aea1"
  url         = "https://token.actions.githubusercontent.com"
  tags        = local.common_tags
}

module "github_actions_deploy_lambda_policy" {
  count         = local.apply_environment
  source        = "./da-terraform-modules/iam_policy"
  name          = "TDRGithubActionsDeployLambda${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_deploy_lambda_actions.json.tpl", { account_id = local.account_id, environment = local.environment, region = local.region })
}

module "github_actions_role" {
  count              = local.apply_environment
  source             = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", { account_id = local.account_id, repo_name = "tdr-*" })
  tags               = local.common_tags
  name               = "TDRGithubActionsDeployLambda${title(local.environment)}"
  policy_attachments = {
    deploy_lambda = module.github_actions_deploy_lambda_policy.policy_arn
  }
}