# tdr-terraform-github

**Important Note**: tdr-terraform-github uses v1.5.0 of Terraform. Ensure that Terraform v1.5.0 is installed before proceeding.

This repository contains the Terraform code to create the AWS resources needed to support the TDR Github Actions for the TDR Github repositories

The Terraform is divided into two types:
* *repository*: GitHub Actions repository level secrets and variables
* *environment*: GitHub Actions environment level secrets and 

## Terraform Workspaces Usage

Four Terraform Workspaces are used:
* `mgmt` workspace: contains the "repository" secrets and variables
* `intg` workspace: contains the "environment" secrets and variables for the TDR intg environment
* `staging` workspace: contains the "environment" secrets and variables for the TDR staging environment
* `prod` workspace: contains the "environment" secrets and variables for the TDR prod environment

The "environment" secrets and variables correspond to the TDR environments (intg, staging, production), these make use of the "intg", "staging", "prod" workspaces

The "repository" secrets and variables correspond to the those common across the different TDR environments, these use the "mgmt" workspace

## Getting Started

### Install Terraform locally

See: https://learn.hashicorp.com/terraform/getting-started/install.html

### Add sub-modules

Some of the resources created by this project depend on other GitHub repositories and should be added as sub-modules:
* [da-terraform-modules](https://github.com/nationalarchives/da-terraform-modules/)
* [da-terraform-configurations](https://github.com/nationalarchives/da-terraform-configurations/)
* [tdr-configurations](https://github.com/nationalarchives/tdr-configurations/)

These sub-modules should be cloned into the project:

   ```
   [location of project] $ git clone [sub-module URL]   
   ```

## Running the Project

1. Add AWS credentials to the local credential store (~/.aws/credentials) for the TDR management account:

   ```
   ... other credentials ...
   [management]
   aws_access_key_id = ... management user access key ...
   aws_secret_access_key = ... management user secret key ...
   ```

2. Run the following command to ensure Terraform uses the correct credentials and environment variables:

   ```
   [location of project] $ export AWS_PROFILE=management
   [location of project] $ export GITHUB_TOKEN=[valid token with access to TDR GitHub repos. Can use token from SSM parameter store: /mgmt/github/jenkins-api-key]
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
