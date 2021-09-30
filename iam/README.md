# iam-control-checks

## Features

- Set up IAM Password Policy.
- Create default IAM roles for managing AWS account.

## CIS controls implemented
- 1.5 Ensure IAM password policy requires at least one uppercase letter
- 1.6 Ensure IAM password policy require at least one lowercase letter
- 1.7 Ensure IAM password policy require at least one symbol
- 1.8 Ensure IAM password policy require at least one number
- 1.9 Ensure IAM password policy requires minimum length of 14 or greater
- 1.10 Ensure IAM password policy prevents password reuse
- 1.11 Ensure IAM password policy expires passwords within 90 days or less
- 1.18 Ensure IAM Master and IAM Manager roles are active
- 1.22 Ensure a support role has been created to manage incidents with AWS Support

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| require_uppercase_characters | Whether to require uppercase characters for user passwords. | string | `true` | no |
| require_lowercase_characters | Whether to require lowercase characters for user passwords. | string | `true` | no |
| require_symbols | Whether to require symbols for user passwords. | string | `true` | no |
| require_numbers | Whether to require numbers for user passwords. | string | `true` | no |
| minimum_password_length | Minimum length to require for user passwords. | string | `14` | no |
| password_reuse_prevention | The number of previous passwords that users are prevented from reusing. | string | `10` | no |
| max_password_age | The number of days that an user password is valid. | string | `90` | no |
| allow_users_to_change_password | Whether to allow users to change their own password. | string | `true` | no |
| aws_account_id | The AWS Account ID number of the account. | string | - | yes |
| master_iam_role_name | The name of the IAM Master role. | string | `IAM-Master` | no |
| master_iam_role_policy_name | The name of the IAM Master role policy. | string | `IAM-Master-Policy` | no |
| manager_iam_role_name | The name of the IAM Manager role. | string | `IAM-Manager` | no |
| manager_iam_role_policy_name | The name of the IAM Manager role policy. | string | `IAM-Manager-Policy` | no |
| support_iam_role_name | The name of the the support role. | string | `IAM-Support` | no |
| support_iam_role_policy_name | The name of the support role policy. | string | `IAM-Support-Role` | no |
| support_iam_role_principal_arn | The ARN of the IAM principal element by which the support role could be assumed. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| master_iam_role_arn | The ARN of the IAM role used for the master user. |
| master_iam_role_name | The name of the IAM role used for the master user. |
| manager_iam_role_arn | The ARN of the IAM role used for the manager user. |
| manager_iam_role_name | The name of the IAM role used for the manager user. |
| support_iam_role_arn | The ARN of the IAM role used for the support user. |
| support_iam_role_name | The name of the IAM role used for the support user. |
