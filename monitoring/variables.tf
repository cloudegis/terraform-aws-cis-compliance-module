variable "alarm_namespace" {
  description = "The namespace in which all alarms are set up."
  default     = "ComplianceBenchmark"
}

variable "cloudtrail_log_group_name" {
  description = "The name of the CloudWatch Logs group to which CloudTrail events are delivered."
}

variable "sns_topic_name" {
  description = "The name of the SNS Topic which will be notified when any alarm is performed."
  default     = "ComplianceAlarmNotifications"
}
