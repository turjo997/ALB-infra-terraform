module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

  vpc_name         = var.vpc_name
  subnet_name      = var.subnet_name
  igw_name         = var.igw_name
  route_table_name = var.route_table_name
}

module "sg_alb" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id
  name   = "turjo-alb-sg"

  ingress_rules = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr      = "0.0.0.0/0"
    }
  ]
}

module "sg_web" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id
  name   = "turjo-web-sg"

  ingress_rules = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      sg        = module.sg_alb.sg_id
    }
  ]
}

module "amazon_ec2" {
  source = "./modules/ec2"

  ami           = var.apache_ami_id
  instance_type = "t3a.micro"
  subnet_id     = module.vpc.public_subnet_ids[0]
  key_name      = "amazon-pub-key"
  sg_id         = module.sg_web.sg_id
  instance_name = "Turjo-Alb-Apache-Server"
}

module "ubuntu_ec2" {
  source = "./modules/ec2"

  ami           = var.nginx_ami_id
  instance_type = "t3a.micro"
  subnet_id     = module.vpc.public_subnet_ids[1]
  key_name      = "ubuntu-pub-key"
  sg_id         = module.sg_web.sg_id
  instance_name = "Turjo-Alb-Nginx-Server"
}

module "alb" {
  source = "./modules/alb"

  alb_name  = "turjo-alb"
  subnet_ids = module.vpc.public_subnet_ids
  sg_id     = module.sg_alb.sg_id
  vpc_id    = module.vpc.vpc_id

  apache_instance_id = module.amazon_ec2.instance_id
  nginx_instance_id  = module.ubuntu_ec2.instance_id
}