variable "account_id" {}

variable "region" {}

variable "environment" {}

variable "common_tags" {}

variable "internal_buckets_kms_key_arn" {
  description = "The arn of the customer managed KMS key used to encrypt internal s3 buckets in this environment"
  type        = string
}