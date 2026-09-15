// Because this is a bootstrap stack, local role config is used
provider "aws" {
  region  = "eu-west-2"
  profile = "TNA__TDRManagement__AdministratorAccess"
}

provider "aws" {
  alias   = "dev"
  region  = "eu-west-2"
  profile = "TNA__TDRDevelopment__AdministratorAccess"
}

provider "aws" {
  alias   = "intg"
  region  = "eu-west-2"
  profile = "TNA__TDRIntegration__AdministratorAccess"
}

provider "aws" {
  alias   = "staging"
  region  = "eu-west-2"
  profile = "TNA__TDRStaging__AdministratorAccess"

}

provider "aws" {
  alias   = "prod"
  region  = "eu-west-2"
  profile = "TNA__TDRProduction__AdministratorAccess"
}

provider "github" {
  owner = "nationalarchives"
}
