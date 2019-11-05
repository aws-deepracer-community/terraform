variable "aws_account_id" {}
variable "vpc_flow_logs_iam_role_arn" {}

module "secure-baseline_vpc-baseline" {
  source  = "nozaq/secure-baseline/aws//modules/vpc-baseline"
  version = "0.16.1"
  # Required
  vpc_log_group_name = var.vpc_default_log_group_name
  vpc_log_retention_in_days = var.vpc_log_retention_in_days
  vpc_flow_logs_iam_role_arn = var.vpc_flow_logs_iam_role_arn
}

resource "aws_vpc" "deepracer_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "Deepracer",
    Terraform = true
  }
}

resource "aws_subnet" "deepracer_subnet_1" {
  vpc_id     = "${aws_vpc.deepracer_vpc.id}"
  cidr_block = var.vpc_subnet_1

  tags = {
    Name = "Public Subnet 1",
    Terraform = true
  }
}

resource "aws_subnet" "deepracer_subnet_2" {
  vpc_id     = "${aws_vpc.deepracer_vpc.id}"
  cidr_block = var.vpc_subnet_2

  tags = {
    Name = "Public Subnet 2",
    Terraform = true
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.deepracer_vpc.id}"

  tags = {
    Name = "Deepracer",
    Terraform = true
  }
}

resource "aws_route_table" "deepracer_aws_route_table" {
  vpc_id = "${aws_vpc.deepracer_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "Deepracer",
    Terraform = true
  }
}

resource "aws_route_table_association" "deepracer_rtassoc_1" {
  subnet_id      = "${aws_subnet.deepracer_subnet_1.id}"
  route_table_id = "${aws_route_table.deepracer_aws_route_table.id}"
}

resource "aws_route_table_association" "deepracer_rtassoc_2" {
  subnet_id      = "${aws_subnet.deepracer_subnet_2.id}"
  route_table_id = "${aws_route_table.deepracer_aws_route_table.id}"
}

// Create security groups
module "vpc_security_groups" {
  source = "./security_groups"
  vpc_id = aws_vpc.deepracer_vpc.id
}

output "allow_http_id" {
  value = module.vpc_security_groups.allow_http_id
}

output "allow_https_id" {
  value = module.vpc_security_groups.allow_https_id
}

output "allow_ssh_id" {
  value = module.vpc_security_groups.allow_ssh_id
}

output "allow_http_outbound_id" {
  value = module.vpc_security_groups.allow_http_outbound_id
}

output "allow_https_outbound_id" {
  value = module.vpc_security_groups.allow_https_outbound_id
}

output "vpc_id" {
  value = aws_vpc.deepracer_vpc.id
}

output "subnet_1" {
  value = aws_subnet.deepracer_subnet_1.id
}

output "subnet_2" {
  value = aws_subnet.deepracer_subnet_2.id
}
