variable "aws_account_id" {}
variable "support_iam_role_principal_arn" {}

module "secure-baseline_iam-baseline" {
  source  = "nozaq/secure-baseline/aws//modules/iam-baseline"
  version = "0.16.1"
  aws_account_id = var.aws_account_id
  support_iam_role_principal_arn = var.support_iam_role_principal_arn
}

//TODO: Move to it's own module
resource "aws_iam_role" "FlowLogs" {
  name = "FlowLogs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    tag-key = "Terraform",
    Terraform = true
  }
}

output "aws_account_id" {
  value = var.aws_account_id
}

output "vpc_flow_logs_iam_role_arn" {
  value = aws_iam_role.FlowLogs.arn
}
