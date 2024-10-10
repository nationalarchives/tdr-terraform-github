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
}

module "github_rotate_personal_access_token_event" {
  count  = local.apply_repository
  source = "./da-terraform-modules/cloudwatch_events"
  event_pattern = templatefile("${path.module}/templates/ssm_parameter_policy_action_pattern.json.tpl", {
    parameter_name = local.github_access_token_name,
    policy_type    = "NoChangeNotification"
  })
  sns_topic_event_target_arn = module.configuration.terraform_config[local.environment]["notifications_sns_topic_arn"]
  rule_name                  = "rotate-github-personal-access-token"
  rule_description           = "Notify to rotate github personal access token"
}

module "github_rotate_enterprise_personal_access_token_event" {
  count  = local.apply_repository
  source = "./da-terraform-modules/cloudwatch_events"
  event_pattern = templatefile("${path.module}/templates/ssm_parameter_policy_action_pattern.json.tpl", {
    parameter_name = local.github_enterprise_access_token_name,
    policy_type    = "NoChangeNotification"
  })
  sns_topic_event_target_arn = module.configuration.terraform_config[local.environment]["notifications_sns_topic_arn"]
  rule_name                  = "rotate-github-enterprise-personal-access-token"
  rule_description           = "Notify to rotate github enterprise personal access token"
}

module "github_keycloak_user_management_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-keycloak-user-management"
  secrets = {
    MANAGEMENT_ACCOUNT     = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_FAILURE_WORKFLOW = data.aws_ssm_parameter.slack_failure_workflow.value
    SLACK_SUCCESS_WORKFLOW = data.aws_ssm_parameter.slack_success_workflow.value
    WORKFLOW_PAT           = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_reporting_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-reporting"
  collaborators   = module.global_parameters.collaborators
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_transfer_frontend_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-transfer-frontend"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_tdr_xray_logging_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-xray-logging"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_consignment_api_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-consignment-api"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    AKKA_TOKEN         = module.common_ssm_parameters.params[local.akka_licence_token_name].value
  }
}

module "github_e2e_tests_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-e2e-tests"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_checksum_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-checksum"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_terraform_environments_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-terraform-environments"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_terraform_modules_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-terraform-modules"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_terraform_backend_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-terraform-backend"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_terraform_github_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-terraform-github"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_auth_utils_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-auth-utils"
  secrets = {
    WORKFLOW_PAT      = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK     = data.aws_ssm_parameter.slack_webhook_url.value
    GPG_PASSPHRASE    = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY   = data.aws_ssm_parameter.enterprise_gpg_private_key.value
    SONATYPE_USERNAME = data.aws_ssm_parameter.sonatype_username.value
    SONATYPE_PASSWORD = data.aws_ssm_parameter.sonatype_password.value
  }
}

module "github_actions_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-github-actions"
  secrets = {
    GPG_KEY_ID      = data.aws_ssm_parameter.enterprise_gpg_key_id.value
    GPG_PASSPHRASE  = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY = data.aws_ssm_parameter.enterprise_gpg_private_key.value
    WORKFLOW_PAT    = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_generated_graphql_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-generated-graphql"
  secrets = {
    WORKFLOW_PAT      = data.aws_ssm_parameter.enterprise_access_token.value
    NPM_TOKEN         = data.aws_ssm_parameter.npm_token.value
    SLACK_WEBHOOK     = data.aws_ssm_parameter.slack_webhook_url.value
    GPG_PASSPHRASE    = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY   = data.aws_ssm_parameter.enterprise_gpg_private_key.value
    SONATYPE_USERNAME = data.aws_ssm_parameter.sonatype_username.value
    SONATYPE_PASSWORD = data.aws_ssm_parameter.sonatype_password.value
  }
  dependabot_secrets = {
    WORKFLOW_PAT = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_graphql_client_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-graphql-client"
  secrets = {
    WORKFLOW_PAT      = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK     = data.aws_ssm_parameter.slack_webhook_url.value
    GPG_PASSPHRASE    = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY   = data.aws_ssm_parameter.enterprise_gpg_private_key.value
    SONATYPE_USERNAME = data.aws_ssm_parameter.sonatype_username.value
    SONATYPE_PASSWORD = data.aws_ssm_parameter.sonatype_password.value
  }
}

module "github_db_migration_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-consignment-api-data"
  secrets = {
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    GPG_PASSPHRASE     = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY    = data.aws_ssm_parameter.enterprise_gpg_private_key.value
    SONATYPE_USERNAME  = data.aws_ssm_parameter.sonatype_username.value
    SONATYPE_PASSWORD  = data.aws_ssm_parameter.sonatype_password.value
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
  }
}

module "github_aws_utils_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-aws-utils"
  secrets = {
    WORKFLOW_PAT      = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK     = data.aws_ssm_parameter.slack_webhook_url.value
    GPG_PASSPHRASE    = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY   = data.aws_ssm_parameter.enterprise_gpg_private_key.value
    SONATYPE_USERNAME = data.aws_ssm_parameter.sonatype_username.value
    SONATYPE_PASSWORD = data.aws_ssm_parameter.sonatype_password.value
  }
}

module "github_auth_server_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-auth-server"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_consignment_export_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-consignment-export"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    GPG_PASSPHRASE     = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY    = data.aws_ssm_parameter.enterprise_gpg_private_key.value
  }
}

module "github_antivirus_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-antivirus"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_backend_checks_performance_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-backend-check-performance"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SANDBOX_ACCOUNT    = data.aws_ssm_parameter.sandbox_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    GPG_PASSPHRASE     = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY    = data.aws_ssm_parameter.enterprise_gpg_private_key.value
  }
}

module "github_scripts_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-scripts"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_notifications_webhook_url.value
    GPG_PASSPHRASE     = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY    = data.aws_ssm_parameter.enterprise_gpg_private_key.value
    SLACK_BOT_TOKEN    = data.aws_ssm_parameter.slack_bot_token.value
  }
}

module "github_aws_accounts_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-aws-accounts"
  secrets = merge(local.account_secrets["intg"], local.account_secrets["staging"], local.account_secrets["prod"], local.account_secrets["mgmt"], {
    TDR_MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    TDR_SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_notifications_webhook_url.value
    TDR_WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    TDR_EMAIL_ADDRESS      = "tdr-secops@nationalarchives.gov.uk"
  })
}

module "github_api_update_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-api-update"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_export_authoriser_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-consignment-export-authoriser"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_create_db_users_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-create-db-users"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_export_status_update_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-export-status-update"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_tna_custodian_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tna-custodian"
  secrets = merge(local.account_secrets["intg"], local.account_secrets["staging"], local.account_secrets["prod"], local.account_secrets["mgmt"], {
    TDR_MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    TDR_SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_notifications_webhook_url.value
    TDR_WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    TDR_EMAIL_ADDRESS      = "tdr-secops@nationalarchives.gov.uk"
  })
}

module "github_dev_documentation_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-dev-documentation"
  secrets = {
    SLACK_WEBHOOK = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_dev_documentation_internal_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-dev-documentation-internal"
  secrets = {
    SLACK_WEBHOOK = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_download_files_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-download-files"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_ecr_scan_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-ecr-scan"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_file_format_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-file-format"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    GPG_PASSPHRASE     = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY    = data.aws_ssm_parameter.enterprise_gpg_private_key.value
  }
}

module "github_file_metadata_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-file-metadata"
  secrets = {
    SLACK_WEBHOOK   = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT    = data.aws_ssm_parameter.enterprise_access_token.value
    NPM_TOKEN       = data.aws_ssm_parameter.npm_token.value
    GPG_PASSPHRASE  = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY = data.aws_ssm_parameter.enterprise_gpg_private_key.value
  }
}

module "github_notifications_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-notifications"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_pr_monitor_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/pull-request-monitor"
  secrets = {
    SLACK_WEBHOOK = data.aws_ssm_parameter.slack_pr_monitor_url.value
    WORKFLOW_PAT  = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_service_unavailable_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-service-unavailable"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_signed_cookies_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-signed-cookies"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_rotate_keycloak_secrets_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-rotate-keycloak-secrets"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_components_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-components"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    NPM_TOKEN          = data.aws_ssm_parameter.npm_token.value
    GPG_PASSPHRASE     = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY    = data.aws_ssm_parameter.enterprise_gpg_private_key.value
  }
}

module "github_file_upload_data_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-file-upload-data"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_backend_checks_utils_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-backend-checks-utils"
  secrets = {
    WORKFLOW_PAT      = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK     = data.aws_ssm_parameter.slack_webhook_url.value
    GPG_PASSPHRASE    = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY   = data.aws_ssm_parameter.enterprise_gpg_private_key.value
    SONATYPE_USERNAME = data.aws_ssm_parameter.sonatype_username.value
    SONATYPE_PASSWORD = data.aws_ssm_parameter.sonatype_password.value
  }
}

module "github_backend_checks_results_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-backend-checks-results"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_redacted_files_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-redacted-files"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_statuses_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-statuses"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}

module "github_terraform_repository" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-terraform-environments"
  secrets = {
    "${upper(local.environment)}_ACCOUNT_NUMBER" = local.account_id
  }
}

module "github_tdr_scripts_repository" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-scripts"
  secrets = {
    "${upper(local.environment)}_ACCOUNT_NUMBER" = local.account_id
  }
}

module "github_metadata_validation_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-metadata-validation"
  secrets = {
    WORKFLOW_PAT      = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK     = data.aws_ssm_parameter.slack_webhook_url.value
    GPG_PASSPHRASE    = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY   = data.aws_ssm_parameter.enterprise_gpg_private_key.value
    SONATYPE_USERNAME = data.aws_ssm_parameter.sonatype_username.value
    SONATYPE_PASSWORD = data.aws_ssm_parameter.sonatype_password.value
  }
}

module "github_draft_metadata_validator_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-draft-metadata-validator"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_metadata_schema_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/da-metadata-schema"
  secrets = {
    WORKFLOW_PAT      = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK     = data.aws_ssm_parameter.slack_webhook_url.value
    GPG_PASSPHRASE    = data.aws_ssm_parameter.enterprise_gpg_passphrase.value
    GPG_PRIVATE_KEY   = data.aws_ssm_parameter.enterprise_gpg_private_key.value
    SONATYPE_USERNAME = data.aws_ssm_parameter.sonatype_username.value
    SONATYPE_PASSWORD = data.aws_ssm_parameter.sonatype_password.value
  }
}

module "github_transfer_service_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-transfer-service"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
  }
}

module "github_dataload_processing_repository" {
  count           = local.apply_repository
  source          = "./da-terraform-modules/github_repository_secrets"
  repository_name = "nationalarchives/tdr-dataload-processing"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_ssm_parameter.mgmt_account_number.value
    SLACK_WEBHOOK      = data.aws_ssm_parameter.slack_webhook_url.value
    WORKFLOW_PAT       = data.aws_ssm_parameter.enterprise_access_token.value
  }
}
