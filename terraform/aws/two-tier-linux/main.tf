provider "aws" {
  version = "2.69.0"
  region  = "eu-west-2"
}


variable "subnetid" {
  type        = string
  description = "Subnet Id"
}

variable "subnetid2" {
  type        = string
  description = "Subnet Id2"
}

variable "name" {
  type        = string
  description = "rds name"
}

variable "username" {
  type        = string
  description = "db username"
}

variable "password" {
  type        = string
  description = "db password"
}
resource "aws_db_subnet_group" "_" {
  name       = "${var.name}-subnet-group"
  subnet_ids = [var.subnetid,var.subnetid2]
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = var.name
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  publicly_accessible     = false
  skip_final_snapshot  = true
  db_subnet_group_name    = aws_db_subnet_group._.id
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

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  #subnet_id is specific to my VPC. Change it!
  subnet_id = var.subnetid

}
