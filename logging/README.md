# logging-control-checks

## Features

- Creates a Cloudtrail S3 bucket with access logging enabled.
- Enable CloudTrail in all regions and deliver events to CloudWatch Logs.
- CloudTrail logs are encrypted using AWS Key Management Service.

## CIS controls implemented
- 2.1 Ensure CloudTrail is enabled in all regions
- 2.2 Ensure CloudTrail log file validation is enabled
- 2.3 Ensure the S3 bucket CloudTrail logs to is not publicly accessible
- 2.4 Ensure CloudTrail trails are integrated with CloudWatch Logs
- 2.6 Ensure S3 bucket access logging is enabled on the CloudTrail S3 bucket
- 2.7 Ensure CloudTrail logs are encrypted at rest using KMS CMKs
- 2.8 Ensure rotation for customer created CMKs is enabled

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| audit_s3_bucket_name | The name of the S3 bucket which will store cloudtrail logs and configuration snapshots. | string | - | yes |
| s3_access_log_bucket_name | The name of the S3 bucket which will store aduit s3 bucket access logs | string | - | yes |
| aws_account_id | The AWS Account ID number of the account. | string | - | yes |
| cloudtrail_name | The name of the trail. | string | `cloudtrail-multi-region` | no |
| cloudwatch_logs_group_name | The name of CloudWatch Logs group to which CloudTrail events are delivered. | string | `cloudtrail-multi-region` | no |
| iam_role_name | The name of the IAM Role to be used by CloudTrail to delivery logs to CloudWatch Logs group. | string | `CloudTrail-CloudWatch-Delivery-Role` | no |
| iam_role_policy_name | The name of the IAM Role Policy to be used by CloudTrail to delivery logs to CloudWatch Logs group. | string | `CloudTrail-CloudWatch-Delivery-Policy` | no |
| key_deletion_window_in_days | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days. | string | `10` | no |
| cloudtrail_region | The AWS region in which CloudTrail is set up. | string | - | yes |
| s3_key_prefix | The prefix for the specified S3 bucket. | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3_access_log_bucket_arn | The ARN of the S3 bucket used for storing access logs of this bucket. |
| s3_access_log_bucket_id | The ID of the S3 bucket used for storing access logs of this bucket. |
| audit_s3_bucket_arn | The ARN of audit S3 bucket. |
| audit_s3_bucket_id | The ID of audit S3 bucket. |
| cloudtrail_arn | The ARN of the trail for recording events in all regions. |
| cloudtrail_id | The ID of the trail for recording events in all regions. |
| kms_key_arn | The ARN of the KMS key used for encrypting CloudTrail events. |
| kms_key_id | The ID of the KMS key used for encrypting CloudTrail events. |
| log_delivery_iam_role_arn | The ARN of the IAM role used for delivering CloudTrail events to CloudWatch Logs. |
| log_delivery_iam_role_name | The name of the IAM role used for delivering CloudTrail events to CloudWatch Logs. |
| log_group_arn | The ARN of the CloudWatch Logs log group which stores CloudTrail events. |
| log_group_name | The name of the CloudWatch Logs log group which stores CloudTrail events. |
