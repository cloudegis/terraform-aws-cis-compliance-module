# monitoring-control-checks

## Features

- Set up CloudWatch alarms to notify you when critical changes happen in your AWS account.

## CIS controls implemented
- 3.1 Ensure a log metric filter and alarm exist for unauthorized API calls
- 3.2 Ensure a log metric filter and alarm exist for Management Console sign-in without MFA
- 3.3 Ensure a log metric filter and alarm exist for usage of "root" account
- 3.4 Ensure a log metric filter and alarm exist for IAM policy changes
- 3.5 Ensure a log metric filter and alarm exist for CloudTrail configuration changes
- 3.6 Ensure a log metric filter and alarm exist for AWS Management Console authentication failures
- 3.7 Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer created CMKs
- 3.8 Ensure a log metric filter and alarm exist for S3 bucket policy changes
- 3.9 Ensure a log metric filter and alarm exist for AWS Config configuration changes
- 3.10 Ensure a log metric filter and alarm exist for security group changes
- 3.11 Ensure a log metric filter and alarm exist for changes to Network Access Control Lists (NACL)
- 3.12 Ensure a log metric filter and alarm exist for changes to network gateways
- 3.13 Ensure a log metric filter and alarm exist for route table changes
- 3.14 Ensure a log metric filter and alarm exist for VPC changes

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_namespace | The namespace in which all alarms are set up. | string | `ComplianceBenchmark` | no |
| cloudtrail_log_group_name | The name of the CloudWatch Logs group to which CloudTrail events are delivered. | string | - | yes |
| sns_topic_name | The name of the SNS Topic which will be notified when any alarm is performed. | string | `ComplianceAlarmNotifications` | no |

## Outputs

| Name | Description |
|------|-------------|
| alarm_topic_arn | The ARN of the SNS topic to which CloudWatch Alarms will be sent. |
