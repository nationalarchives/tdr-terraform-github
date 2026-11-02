// Because this is a bootstrap stack, local role config is used
provider "aws" {
  region  = "eu-west-2"
  profile = "tdr_admin_management"
}

provider "aws" {
  alias   = "dev"
  region  = "eu-west-2"
  profile = "tdr_dev_environment"
}

provider "aws" {
  alias   = "intg"
  region  = "eu-west-2"
  profile = "tdr_intg_environment"
}

provider "aws" {
  alias   = "staging"
  region  = "eu-west-2"
  profile = "tdr_staging_environment"
}

provider "aws" {
  alias   = "prod"
  region  = "eu-west-2"
  profile = "tdr_prod_environment"
}

provider "github" {
  owner = "nationalarchives"
}