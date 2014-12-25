variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret key"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "us-east-1"
}

resource "aws_vpc" "tf_test" {
  cidr_block = "10.4.0.0/16"
  tags { Name = "vpc-tf-test" }
}

resource "aws_security_group" "allow_all" {
  name = "tf-test"
  description = "SG for testing terraform destroy on unchanged update bug"
  vpc_id = "${aws_vpc.tf_test.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "terraform-test" }
}
