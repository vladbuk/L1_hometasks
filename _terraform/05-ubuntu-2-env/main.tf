provider "aws" {
    region = "eu-central-1"
    profile = "vladbuk"
    shared_credentials_files = [ "$HOME/.aws/credentials" ]
}

data "aws_ami" "ubuntu20_latest" {
    owners = [ "099720109477" ]
    most_recent = true
    
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}

resource "aws_instance" "t2micro_ubuntu_prod" {
    ami = data.aws_ami.ubuntu20_latest.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.allow_http.id, aws_security_group.allow_ssh.id ]
    key_name = "ter_aws_key"
    tags = {
        Name = "t2micro_ubuntu_prod"
        Env = "production"
    }
    //user_data = file("user_data.sh")
    lifecycle {
      //prevent_destroy = true
      //create_before_destroy = true
    }
}

resource "aws_instance" "t2micro_ubuntu_test" {
    ami = data.aws_ami.ubuntu20_latest.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.allow_http.id, aws_security_group.allow_ssh.id ]
    key_name = "ter_aws_key"
    tags = {
        Name = "t2micro_ubuntu_test"
        Env = "testing"
    }
    //user_data = file("user_data.sh")
    lifecycle {
      //prevent_destroy = true
      //create_before_destroy = true
    }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic" 

  dynamic "ingress" {
    for_each = ["80", "10500", "3000"]
    content {
      description      = "http from VPC"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  ingress {
    description      = "icmp from VPC"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound all packets"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_https"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"  

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}