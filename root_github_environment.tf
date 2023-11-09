module "github_keycloak_user_management_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-keycloak-user-management"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    TITLE_STAGE    = title(local.environment)
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_reporting_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-reporting"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_consignment_api_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-consignment-api"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_e2e_tests_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-e2e-tests"
  secrets = {
    "${upper(local.environment)}_ACCOUNT_NUMBER" = local.account_id
  }
}

module "github_transfer_frontend_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-transfer-frontend"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_tdr_xray_logging_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-xray-logging"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_terraform_environment" {
  count                 = local.apply_environment
  source                = "./da-terraform-modules/github_environment_secrets"
  environment           = local.environment
  repository_name       = "nationalarchives/tdr-terraform-environments"
  team_slug             = "transfer-digital-records-admins"
  integration_team_slug = ["transfer-digital-records"]
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_checksum_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-checksum"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_db_migrations_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-consignment-api-data"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_auth_server_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-auth-server"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_antivirus_server_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-antivirus"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_consignment_export_server_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-consignment-export"
  team_slug       = "transfer-digital-records-admins"
}

module "github_aws_accounts_environment" {
  count                 = local.apply_environment
  source                = "./da-terraform-modules/github_environment_secrets"
  environment           = local.environment
  repository_name       = "nationalarchives/tdr-aws-accounts"
  team_slug             = "transfer-digital-records-admins"
  integration_team_slug = ["transfer-digital-records"]
}

module "github_tdr_scripts_environment" {
  count                 = local.apply_environment
  source                = "./da-terraform-modules/github_environment_secrets"
  environment           = local.environment
  repository_name       = "nationalarchives/tdr-scripts"
  team_slug             = "transfer-digital-records-admins"
  integration_team_slug = ["transfer-digital-records"]
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_api_update_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-api-update"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_export_status_update_update_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-export-status-update"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_export_authoriser_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-consignment-export-authoriser"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_create_db_users_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-create-db-users"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_custodian_environment" {
  count                 = local.apply_environment
  source                = "./da-terraform-modules/github_environment_secrets"
  environment           = "tdr-${local.environment}"
  repository_name       = "nationalarchives/tna-custodian"
  team_slug             = "transfer-digital-records-admins"
  integration_team_slug = ["transfer-digital-records"]
}

module "github_download_files_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-download-files"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_file_format_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-file-format"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_notifications_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-notifications"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_service_unavailable_environment" {
  count                 = local.apply_environment
  source                = "./da-terraform-modules/github_environment_secrets"
  environment           = local.environment
  repository_name       = "nationalarchives/tdr-service-unavailable"
  team_slug             = "transfer-digital-records-admins"
  integration_team_slug = ["transfer-digital-records"]
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_sign_cookies_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-sign-cookies"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_signed_cookies_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-signed-cookies"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_rotate_secrets_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-rotate-keycloak-secrets"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_file_upload_data_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-file-upload-data"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_backend_checks_results_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-backend-checks-results"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_statuses_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-statuses"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_ecr_scan_environment" {
  count           = local.mgmt_apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = "mgmt"
  repository_name = "nationalarchives/tdr-ecr-scan"
  team_slug       = "transfer-digital-records-admins"
}

module "github_notifications_mgmt_environment" {
  count                 = local.mgmt_apply_environment
  source                = "./da-terraform-modules/github_environment_secrets"
  environment           = "mgmt"
  repository_name       = "nationalarchives/tdr-notifications"
  team_slug             = "transfer-digital-records-admins"
  integration_team_slug = ["transfer-digital-records"]
  secrets = {
    ACCOUNT_NUMBER = data.aws_ssm_parameter.mgmt_account_number.value
  }
}

//New Stuff
module "github_oidc_provider" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/openid_provider"
  audience        = "sts.amazonaws.com"
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
  url             = "https://token.actions.githubusercontent.com"
  tags            = local.common_tags
}

module "github_actions_deploy_lambda_policy" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGithubActionsDeployLambda${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/deploy_lambda_github_actions.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, environment = local.environment, region = local.region
  })
}

module "github_actions_role" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-*"
  })
  tags = local.common_tags
  name = "TDRGithubActionsDeployLambda${title(local.environment)}"
  policy_attachments = {
    deploy_lambda = module.github_actions_deploy_lambda_policy[count.index].policy_arn
  }
}

module "github_run_e2e_tests_policy" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGithubActionsRunE2ETestsPolicy${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_run_e2e_tests_policy.json.tpl", {
    environment = local.environment
  })
}

module "github_run_e2e_tests_role" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
  })
  tags = local.common_tags
  name = "TDRGithubActionsRunE2ETestsRole${title(local.environment)}"
  policy_attachments = {
    run_tests_policy = module.github_run_e2e_tests_policy[count.index].policy_arn
  }
}

module "github_update_ecs_policy" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGitHubECSUpdatePolicy${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_update_ecs_policy.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, region = local.region, environment = local.environment
  })
}

module "github_update_ecs_role" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-"
  })
  tags = local.common_tags
  name = "TDRGitHubECSUpdateRole${title(local.environment)}"
  policy_attachments = {
    update_ecs_policy = module.github_update_ecs_policy[count.index].policy_arn
  }
}

module "github_get_e2e_secrets_policy" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGithubActionsE2ESecretsPolicy${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_e2e_test_secrets_policy.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, environment = local.environment
  })
}

module "github_get_e2e_tests_secrets" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-"
  })
  tags = local.common_tags
  name = "TDRGithubActionsGetE2ESecretsRole${title(local.environment)}"
  policy_attachments = {
    get_ssm_policy = module.github_get_e2e_secrets_policy[count.index].policy_arn
  }
}

module "github_create_db_user_policy" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGithubActionsInvokeCreateUserLambdaPolicy${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_invoke_create_user_lambda_policy.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, environment = local.environment
  })
}

module "github_create_db_user_role" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id
  })
  tags               = local.common_tags
  name               = "TDRGithubActionsInvokeCreateUserLambdaRole${title(local.environment)}"
  policy_attachments = { create_user_policy = module.github_create_db_user_policy[count.index].policy_arn }
}

module "github_file_format_run_ecs_role" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_role"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = data.aws_caller_identity.current.account_id, repo_name = "tdr-*"
  })
  tags = local.common_tags
  name = "TDRGithubActionsRunFileFormatECS${title(local.environment)}"
  policy_attachments = {
    run_file_format = module.github_run_file_format_build_policy[count.index].policy_arn
  }
}

module "github_run_file_format_build_policy" {
  count  = local.apply_environment
  source = "./da-terraform-modules/iam_policy"
  name   = "TDRGitHubRunFileFormatBuildPolicy${title(local.environment)}"
  policy_string = templatefile("${path.module}/templates/iam_policy/github_run_ecs_policy.json.tpl",
    {
      task_definition_arn = "arn:aws:ecs:${local.region}:${data.aws_caller_identity.current.account_id}:task-definition/file-format-build-${local.environment}",
      cluster_arn         = "arn:aws:ecs:${local.region}:${data.aws_caller_identity.current.account_id}:cluster/file_format_build_${local.environment}",
      role_arns           = "\"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TDRFileFormatEcsTaskRole${title(local.environment)}\", \"arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TDRFileFormatECSExecutionRole${title(local.environment)}\""
  })
}
