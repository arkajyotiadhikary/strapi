module "security_group" {
  source = "./modules/security-group"
  vpc_id = var.vpc_id
}

module "ec2" {
  source              = "./modules/ec2"
  ami_id              = data.aws_ami.ubuntu.id
  instance_type       = var.instance_type
  subnet_id           = var.subnet_id
  security_group_id   = module.security_group.security_group_id
  key_name            = var.key_name
  user                = var.user
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}