module "secgroup" {
  source = "./secgroup"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}
