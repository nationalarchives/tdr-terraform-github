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

module "intg_github_iam_roles_policies" {
  count  = local.intg_apply
  source = "./modules/iam_environment_roles_policies"
  providers = {
    aws = aws.intg
  }
  region          = local.region
  account_id      = local.intg_account_id
  environment     = local.intg_environment
  common_tags     = local.common_tags
  mgmt_account_id = data.aws_ssm_parameter.mgmt_account_number.value
}

module "staging_github_iam_roles_policies" {
  count  = local.staging_apply
  source = "./modules/iam_environment_roles_policies"
  providers = {
    aws = aws.staging
  }
  region          = local.region
  account_id      = local.staging_account_id
  environment     = local.staging_environment
  common_tags     = local.common_tags
  mgmt_account_id = data.aws_ssm_parameter.mgmt_account_number.value
}

module "prod_github_iam_roles_policies" {
  count  = local.prod_apply
  source = "./modules/iam_environment_roles_policies"
  providers = {
    aws = aws.prod
  }
  region          = local.region
  account_id      = local.prod_account_id
  environment     = local.prod_environment
  common_tags     = local.common_tags
  mgmt_account_id = data.aws_ssm_parameter.mgmt_account_number.value
}

module "intg_github_iam_testing_roles_policies" {
  count  = local.intg_apply
  source = "./modules/iam_environment_testing_roles_policies"
  providers = {
    aws = aws.intg
  }
  region                         = local.region
  account_id                     = local.intg_account_id
  environment                    = local.intg_environment
  common_tags                    = local.common_tags
  internal_buckets_kms_key_alias = local.internal_buckets_kms_key_alias
}

module "staging_github_iam_testing_roles_policies" {
  count  = local.staging_apply
  source = "./modules/iam_environment_testing_roles_policies"
  providers = {
    aws = aws.staging
  }
  region                         = local.region
  account_id                     = local.staging_account_id
  environment                    = local.staging_environment
  common_tags                    = local.common_tags
  internal_buckets_kms_key_alias = local.internal_buckets_kms_key_alias
}

module "github_draft_metadata_validator_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-draft-metadata-validator"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_transfer_service_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-transfer-service"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_dataload_processing_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-dataload-processing"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

module "github_external_event_handling_environment" {
  count           = local.apply_environment
  source          = "./da-terraform-modules/github_environment_secrets"
  environment     = local.environment
  repository_name = "nationalarchives/tdr-external-event-handling"
  team_slug       = "transfer-digital-records-admins"
  secrets = {
    ACCOUNT_NUMBER = local.account_id
  }
}

