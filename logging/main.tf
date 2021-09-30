# --------------------------------------------------------------------------------------------------
# Creates a S3 bucket with access logging enabled.
# 2.3 Ensure the S3 bucket CloudTrail logs to is not publicly accessible
# 2.6 Ensure S3 bucket access logging is enabled on the CloudTrail S3 bucket
# --------------------------------------------------------------------------------------------------
resource "aws_kms_key" "access_log" {
  description             = "This key is used to encrypt S3 Access Logs"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "access_log" {
  bucket = var.s3_access_log_bucket_name

  // force_destroy = true

  acl = "log-delivery-write"

  lifecycle_rule {
    id      = "auto-archive"
    enabled = true

    prefix = "/"

    transition {
      days          = var.lifecycle_glacier_transition_days
      storage_class = "GLACIER"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.access_log.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_kms_key" "audit_logs" {
  description             = "This key is used to encrypt S3 Audit Logs"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "audit_logs" {
  bucket = var.audit_s3_bucket_name

  // force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.audit_s3_bucket_name}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.audit_s3_bucket_name}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY


  acl = "private"

  logging {
    target_bucket = aws_s3_bucket.access_log.id
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "auto-archive"
    enabled = true

    prefix = "/"

    transition {
      days          = var.lifecycle_glacier_transition_days
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      days          = var.lifecycle_glacier_transition_days
      storage_class = "GLACIER"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.audit_logs.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# --------------------------------------------------------------------------------------------------
# 2.1 Ensure CloudTrail is enabled in all regions
# 2.2 Ensure CloudTrail log file validation is enabled
# 2.4 Ensure CloudTrail trails are integrated with CloudWatch Logs
# 2.7 Ensure CloudTrail logs are encrypted at rest using KMS CMKs
# --------------------------------------------------------------------------------------------------

resource "aws_cloudtrail" "global" {
  name = var.cloudtrail_name

  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.cloudtrail_events.arn
  cloud_watch_logs_role_arn     = aws_iam_role.cloudwatch_delivery.arn
  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = true
  kms_key_id                    = aws_kms_key.cloudtrail.arn
  s3_bucket_name                = aws_s3_bucket.audit_logs.id
  s3_key_prefix                 = var.cloudtrail_s3_key_prefix

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"

      # Make sure to append a trailing '/' to your ARN if you want
      # to monitor all objects in a bucket.
      values = ["${aws_s3_bucket.audit_logs.arn}/"]
    }
  }
}

# --------------------------------------------------------------------------------------------------
# CloudWatch Logs group to accept CloudTrail event stream.
# --------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "cloudtrail_events" {
  name = var.cloudwatch_logs_group_name
}

resource "aws_iam_role" "cloudwatch_delivery" {
  name = var.iam_role_name

  assume_role_policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
END_OF_POLICY

}

resource "aws_iam_role_policy" "cloudwatch_delivery_policy" {
  name = var.iam_role_policy_name

  role = aws_iam_role.cloudwatch_delivery.id

  policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream2014110",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "arn:aws:logs:${var.cloudtrail_region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail_events.name}:log-stream:*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents20141101",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${var.cloudtrail_region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail_events.name}:log-stream:*"
      ]
    }
  ]
}
END_OF_POLICY

}

# --------------------------------------------------------------------------------------------------
# KMS Key to encrypt CloudTrail events.
# 2.7 Ensure CloudTrail logs are encrypted at rest using KMS CMKs
# 2.8 Ensure rotation for customer created CMKs is enabled
# --------------------------------------------------------------------------------------------------

resource "aws_kms_key" "cloudtrail" {
  description             = "A KMS key to encrypt CloudTrail events."
  deletion_window_in_days = var.key_deletion_window_in_days
  enable_key_rotation     = "true"

  policy = <<END_OF_POLICY
{
    "Version": "2012-10-17",
    "Id": "Key policy created by CloudTrail",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {"AWS": [
                "arn:aws:iam::${var.aws_account_id}:root"
            ]},
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow CloudTrail to encrypt logs",
            "Effect": "Allow",
            "Principal": {"Service": ["cloudtrail.amazonaws.com"]},
            "Action": "kms:GenerateDataKey*",
            "Resource": "*",
            "Condition": {"StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${var.aws_account_id}:trail/*"}}
        },
        {
            "Sid": "Allow CloudTrail to describe key",
            "Effect": "Allow",
            "Principal": {"Service": ["cloudtrail.amazonaws.com"]},
            "Action": "kms:DescribeKey",
            "Resource": "*"
        },
        {
            "Sid": "Allow principals in the account to decrypt log files",
            "Effect": "Allow",
            "Principal": {"AWS": "*"},
            "Action": [
                "kms:Decrypt",
                "kms:ReEncryptFrom"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {"kms:CallerAccount": "${var.aws_account_id}"},
                "StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${var.aws_account_id}:trail/*"}
            }
        },
        {
            "Sid": "Allow alias creation during setup",
            "Effect": "Allow",
            "Principal": {"AWS": "*"},
            "Action": "kms:CreateAlias",
            "Resource": "*",
            "Condition": {"StringEquals": {
                "kms:ViaService": "ec2.${var.cloudtrail_region}.amazonaws.com",
                "kms:CallerAccount": "${var.aws_account_id}"
            }}
        },
        {
            "Sid": "Enable cross account log decryption",
            "Effect": "Allow",
            "Principal": {"AWS": "*"},
            "Action": [
                "kms:Decrypt",
                "kms:ReEncryptFrom"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {"kms:CallerAccount": "${var.aws_account_id}"},
                "StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${var.aws_account_id}:trail/*"}
            }
        }
    ]
}
END_OF_POLICY

}
