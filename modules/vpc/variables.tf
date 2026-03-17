variable "vpc_cidr" {}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "vpc_name" {}
variable "subnet_name" {}
variable "igw_name" {}
variable "route_table_name" {}