variable "alb_name" {}
variable "sg_id" {}
variable "vpc_id" {}
variable "apache_instance_id" {}
variable "nginx_instance_id" {}
variable "subnet_ids" {
  type = list(string)
}