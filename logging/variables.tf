variable "audit_s3_bucket_name" {
  description = "The name of the S3 bucket which will store cloudtrail logs and configuration snapshots."
}

variable "s3_access_log_bucket_name" {
  description = "The name of the S3 bucket which will store audit s3 bucket access logs"
}

variable "lifecycle_glacier_transition_days" {
  description = "The number of days after object creation when the object is archived into Glacier."
  default     = 90
}

variable "aws_account_id" {
  description = "The AWS Account ID number of the account."
}

variable "cloudtrail_name" {
  description = "The name of the trail."
  default     = "cloudtrail-global"
}

variable "cloudwatch_logs_group_name" {
  description = "The name of CloudWatch Logs group to which CloudTrail events are delivered."
  default     = "cloudtrail-multi-region"
}

variable "iam_role_name" {
  description = "The name of the IAM Role to be used by CloudTrail to delivery logs to CloudWatch Logs group."
  default     = "CloudTrail-CloudWatch-Delivery-Role"
}

variable "iam_role_policy_name" {
  description = "The name of the IAM Role Policy to be used by CloudTrail to delivery logs to CloudWatch Logs group."
  default     = "CloudTrail-CloudWatch-Delivery-Policy"
}

variable "key_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."
  default     = 10
}

variable "cloudtrail_region" {
  description = "The AWS region in which CloudTrail is set up."
  default     = "us-east-1"
}

variable "cloudtrail_s3_key_prefix" {
  description = "The prefix for the specified S3 bucket."
  default     = "cloudtrail"
}
