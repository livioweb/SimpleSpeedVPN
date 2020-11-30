variable "region" {
  default = "eu-west-2"
}
variable "vpc_cidr" {
  default = "192.168.0.0/16"
}
variable "public" {
  default = "192.168.1.0/24"
}
variable "ami_vpn" {
  #default = "ami-0e82959d4ed12de3f" #18.04 in us-east-2
  #default = "ami-07efac79022b86107" #20.04
  default = "ami-0e169fa5b2b2f88ae" #18.04 in eu-west-2
}
variable "instance_type" {
  default = "t2.micro"
}

variable "key_pair" {
  default = "terraformvpnr2d2"
}

