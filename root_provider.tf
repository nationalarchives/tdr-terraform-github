//Management account AWS provider
provider "aws" {
  region  = "eu-west-2"
  profile = "management"
}

//AWS providers for TDR environment accounts
provider "aws" {
  alias   = "intg"
  region  = "eu-west-2"
  profile = "management"
  assume_role {
    role_arn     = "arn:aws:iam::${local.account_id}:role/IAM_Admin_Role"
    session_name = "terraform-github"
  }
}

provider "aws" {
  alias   = "staging"
  region  = "eu-west-2"
  profile = "management"
  assume_role {
    role_arn     = "arn:aws:iam::${local.account_id}:role/IAM_Admin_Role"
    session_name = "terraform-github"
  }
}

provider "aws" {
  alias   = "prod"
  region  = "eu-west-2"
  profile = "management"
  assume_role {
    role_arn     = "arn:aws:iam::${local.account_id}:role/IAM_Admin_Role"
    session_name = "terraform-github"
  }
}

provider "github" {
  owner = "nationalarchives"
}
