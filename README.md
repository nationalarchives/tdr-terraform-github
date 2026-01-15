# tdr-terraform-github

**Important Note**: tdr-terraform-github uses >= v1.12.2 of Terraform. Ensure that Terraform >= v1.12.2 is installed before proceeding.

This repository contains the Terraform code to create the AWS resources needed to support the TDR Github Actions for the TDR Github repositories

The Terraform is divided into two types:
* *repository*: GitHub Actions repository level secrets and variables
* *environment*: GitHub Actions environment level secrets and 

There is no GitHub action to deploy this Terraform stack.  Deployment should be done via local machine.

## Terraform Workspaces Usage

Four Terraform Workspaces are used:
* `mgmt` workspace: contains the "repository" secrets and variables
* `intg` workspace: contains the "environment" secrets and variables for the TDR intg environment
* `staging` workspace: contains the "environment" secrets and variables for the TDR staging environment
* `prod` workspace: contains the "environment" secrets and variables for the TDR prod environment

The "environment" secrets and variables correspond to the all TDR environments (intg, staging, production, management), these make use of the "intg", "staging", "prod", "mgmt" workspaces

The "repository" secrets and variables correspond to the those common across the different TDR environments, these use the "mgmt" workspace

## Repository Configuration

The repository requires a set of repository secrets to be configured before it can be used.

These need to be set up manually first as the GitHub actions for the repository will not run without them.

### Repository secrets

* `MANAGEMENT_ACCOUNT`: this value can be found in the TDR management account in the `/mgmt/management_account` SSM parameter
* `SLACK_WEBHOOK`: this value can be found in the TDR management account in the `/mgmt/slack/webhook` SSM parameter
* `WORKFLOW_PAT`: this value can be found in the TDR management account in the `/mgmt/github_enterprise/access_token` SSM parameter

## Getting Started

### Install Terraform locally

See: https://learn.hashicorp.com/terraform/getting-started/install.html

### Clone project with sub-modules

The following submodules are used in this project

* [da-terraform-modules](https://github.com/nationalarchives/da-terraform-modules/)
* [da-terraform-configurations](https://github.com/nationalarchives/da-terraform-configurations/)
* [tdr-configurations](https://github.com/nationalarchives/tdr-configurations/)

Clone the entire project with:

   ```
   [location of project] $ git clone --recurse-submodules git@github.com:nationalarchives/tdr-terraform-github.git   
   ```

## Running the Project

1. Add AWS credentials to the local credential store (~/.aws/credentials) for the TDR management account:

   ```
   ... other credentials ...
   [<a profile that points to management>]
   sso_account_id  = ... management account number  ...
   sso_role_name  = ... management role ...
   ...

   ```

   For the dev environment, no dedicated Admin Role has been created to be assumed by the dev aws provider, instead this too should be added as a profile to `~/.aws/credentials` (or `~/.aws/config` if you are using `aws sso login`):
   
   ```
   [profile dev]
   ...
   sso_account_id             = dev account number
   sso_role_name              = AdministratorAccess
   ...
   ```

2. Run the following command to ensure Terraform uses the correct credentials and environment variables:

   ```
   [location of project] $ export AWS_PROFILE=management
   [location of project] $ export GITHUB_TOKEN=[valid token with access to TDR GitHub repos. You can use your own Github personal access token from Profile > Developer Settings]
   [location of project] $ export GITHUB_OWNER=nationalarchives
   ```

3. Select the *correct* Terraform workspace.
* To apply "repository" secrets and variables select the `mgmt` workspace:
   ```
   [location of project] $ terraform workspace select mgmt   
   ```
* To apply "environment" secrets and variables select one of the following workspaces depending on which TDR environment it is to be applied to: `intg`, `staging`or `prod`
   ```
   [location of project] $ terraform workspace select {intg or staging or prod} 
   ```
4. In the correct Terraform workspace run the `plan` or `apply` Terraform commands as required
  ```
   [location of project] $ terraform {plan or apply} 
   ```
