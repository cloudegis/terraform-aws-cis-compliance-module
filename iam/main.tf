# --------------------------------------------------------------------------------------------------
# IAM Password Policy
# 1.5 Ensure IAM password policy requires at least one uppercase letter
# 1.6 Ensure IAM password policy require at least one lowercase letter
# 1.7 Ensure IAM password policy require at least one symbol
# 1.8 Ensure IAM password policy require at least one number
# 1.9 Ensure IAM password policy requires minimum length of 14 or greater
# 1.10 Ensure IAM password policy prevents password reuse
# 1.11 Ensure IAM password policy expires passwords within 90 days or less
# --------------------------------------------------------------------------------------------------

resource "aws_iam_account_password_policy" "default" {
  require_uppercase_characters   = var.require_uppercase_characters
  require_lowercase_characters   = var.require_lowercase_characters
  require_symbols                = var.require_symbols
  require_numbers                = var.require_numbers
  minimum_password_length        = var.minimum_password_length
  password_reuse_prevention      = var.password_reuse_prevention
  max_password_age               = var.max_password_age
  allow_users_to_change_password = var.allow_users_to_change_password
}

# --------------------------------------------------------------------------------------------------
# 1.18 Ensure IAM Master and IAM Manager roles are active
# --------------------------------------------------------------------------------------------------

resource "aws_iam_role" "master" {
  name = var.master_iam_role_name

  assume_role_policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.aws_account_id}:root"
      }
    }
  ]
}
END_OF_POLICY

}

resource "aws_iam_role_policy" "master_policy" {
  name = var.master_iam_role_policy_name

  role = aws_iam_role.master.id

  policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateGroup", "iam:CreatePolicy", "iam:CreatePolicyVersion", "iam:CreateRole", "iam:CreateUser",
        "iam:DeleteGroup", "iam:DeletePolicy", "iam:DeletePolicyVersion", "iam:DeleteRole", "iam:DeleteRolePolicy", "iam:DeleteUser",
        "iam:PutRolePolicy",
        "iam:GetPolicy", "iam:GetPolicyVersion", "iam:GetRole", "iam:GetRolePolicy", "iam:GetUser", "iam:GetUserPolicy",
        "iam:ListEntitiesForPolicy", "iam:ListGroupPolicies", "iam:ListGroups", "iam:ListGroupsForUser",
        "iam:ListPolicies", "iam:ListPoliciesGrantingServiceAccess", "iam:ListPolicyVersions",
        "iam:ListRolePolicies", "iam:ListAttachedGroupPolicies", "iam:ListAttachedRolePolicies",
        "iam:ListAttachedUserPolicies", "iam:ListRoles", "iam:ListUsers"
      ],
      "Resource": "*",
      "Condition":  {"Bool": {"aws:MultiFactorAuthPresent": "true"}}
    }, {
      "Effect": "Deny",
      "Action": [
        "iam:AddUserToGroup",
        "iam:AttachGroupPolicy",
        "iam:DeleteGroupPolicy", "iam:DeleteUserPolicy",
        "iam:DetachGroupPolicy", "iam:DetachRolePolicy", "iam:DetachUserPolicy",
        "iam:PutGroupPolicy", "iam:PutUserPolicy",
        "iam:RemoveUserFromGroup",
        "iam:UpdateGroup", "iam:UpdateAssumeRolePolicy", "iam:UpdateUser"
      ],
      "Resource": "*"
    }
  ]
}
END_OF_POLICY

}

resource "aws_iam_role" "manager" {
  name = var.manager_iam_role_name

  assume_role_policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.aws_account_id}:root"
      }
    }
  ]
}
END_OF_POLICY

}

resource "aws_iam_role_policy" "manager_policy" {
  name = var.manager_iam_role_policy_name

  role = aws_iam_role.manager.id

  policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:AddUserToGroup",
        "iam:AttachGroupPolicy",
        "iam:DeleteGroupPolicy", "iam:DeleteUserPolicy",
        "iam:DetachGroupPolicy", "iam:DetachRolePolicy","iam:DetachUserPolicy",
        "iam:PutGroupPolicy", "iam:PutUserPolicy",
        "iam:RemoveUserFromGroup",
        "iam:UpdateGroup", "iam:UpdateAssumeRolePolicy", "iam:UpdateUser",
        "iam:GetPolicy", "iam:GetPolicyVersion", "iam:GetRole", "iam:GetRolePolicy", "iam:GetUser", "iam:GetUserPolicy",
        "iam:ListEntitiesForPolicy", "iam:ListGroupPolicies", "iam:ListGroups", "iam:ListGroupsForUser",
        "iam:ListPolicies", "iam:ListPoliciesGrantingServiceAccess", "iam:ListPolicyVersions",
        "iam:ListRolePolicies", "iam:ListAttachedGroupPolicies", "iam:ListAttachedRolePolicies",
        "iam:ListAttachedUserPolicies", "iam:ListRoles", "iam:ListUsers"
      ],
      "Resource": "*",
      "Condition":  {"Bool": {"aws:MultiFactorAuthPresent": "true"}}
    }, {
      "Effect": "Deny",
      "Action": [
        "iam:CreateGroup", "iam:CreatePolicy", "iam:CreatePolicyVersion", "iam:CreateRole", "iam:CreateUser",
        "iam:DeleteGroup", "iam:DeletePolicy", "iam:DeletePolicyVersion", "iam:DeleteRole", "iam:DeleteRolePolicy", "iam:DeleteUser",
        "iam:PutRolePolicy"
      ],
      "Resource": "*"
    }
  ]
}
END_OF_POLICY

}

# --------------------------------------------------------------------------------------------------
# 1.22 Ensure a support role has been created to manage incidents with AWS Support
# --------------------------------------------------------------------------------------------------

resource "aws_iam_role" "support" {
  name = var.support_iam_role_name

  assume_role_policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${var.support_iam_role_principal_arn}"
      }
    }
  ]
}
END_OF_POLICY

}

resource "aws_iam_role_policy_attachment" "support_policy" {
  role       = aws_iam_role.support.id
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}
