variable "cidr_block" {
  default = "10.0.0.0/24"
}
variable "vpc_subnet_1" {
  default = "10.0.0.0/25"
}
variable "vpc_subnet_2" {
  default = "10.0.0.128/25"
}

variable "flow_logs_iam_role_name" {
  default = "DeepracerFlowLogs"
}

variable "vpc_default_log_group_name" {
  default = "vpc_default_flow_logs"
}

variable "vpc_deepracer_log_group_name" {
  default = "vpc_deepracer_flow_logs"
}

variable "vpc_log_retention_in_days" {
  default = "7"
}
