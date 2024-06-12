data "aws_caller_identity" "current" {}

module "global_parameters" {
  source = "../../tdr-configurations/terraform"
}

module "github_run_e2e_tests_policy" {
  source = "../../da-terraform-modules/iam_policy"
  name   = "TDRGithubActionsRunE2ETestsPolicy${title(var.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_run_e2e_tests_policy.json.tpl", {
    environment     = var.environment
    encryption_keys = jsonencode([var.internal_buckets_kms_key_alias])
  })
}

module "github_run_e2e_tests_role" {
  source = "../../da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id,
    repo_names = jsonencode(concat(module.global_parameters.github_tdr_active_repositories, module.global_parameters.github_da_active_repositories))
  })
  tags = var.common_tags
  name = "TDRGithubActionsRunE2ETestsRole${title(var.environment)}"
  policy_attachments = {
    run_tests_policy = module.github_run_e2e_tests_policy.policy_arn
  }
}

module "github_get_e2e_secrets_policy" {
  source = "../../da-terraform-modules/iam_policy"
  name   = "TDRGithubActionsE2ESecretsPolicy${title(var.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_e2e_test_secrets_policy.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, environment = var.environment
  })
}

module "github_get_e2e_tests_secrets" {
  source = "../../da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id,
    repo_names = jsonencode(concat(module.global_parameters.github_tdr_active_repositories, module.global_parameters.github_da_active_repositories))
  })
  tags = var.common_tags
  name = "TDRGithubActionsGetE2ESecretsRole${title(var.environment)}"
  policy_attachments = {
    get_ssm_policy = module.github_get_e2e_secrets_policy.policy_arn
  }
}
