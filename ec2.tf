resource "aws_instance" "vpn_instnace" {
  ami = var.ami_vpn
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.vpn.id]
  subnet_id = aws_subnet.public.id
  #
  #availability_zone = "${var.region}a"
  key_name = var.key_pair
  associate_public_ip_address = true

  connection {
    type = "ssh"
    user = "ubuntu"
    //private_key = file("${var.key_pair}.pem")
    host = self.public_ip
  }

  provisioner "file" {
    source = "vpnsetup.sh"
    destination = "/tmp/vpnsetup.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "sudo apt-get update",
      "chmod +x /tmp/vpnsetup.sh",
      "sudo /tmp/vpnsetup.sh",
    ]
  }

  lifecycle {
    create_before_destroy = true
  }


  tags = {
    Name = "Vpn Instance"
  }
}

resource "aws_security_group" "vpn" {
  name        = "vpn"
  description = "Allow VPN traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPN"
  }
}

resource "aws_key_pair" "deploy" {
  key_name   = var.key_pair
  public_key = file("~/.ssh/id_rsa.pub")

  //public_key = "ssh-rsa ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDoXmBHMI+z1YOx+B/tSWQu8yF5WgIRjdxvTkEOx+I+U6MCL6YnvyJgMAG4gSAh8I9/pAiOpn/JpmXYgwhgWBV6yr8zon4hd5qJM9XJK6MlKJwDD4ag6Qtg/orG3gflf7KObINpjrwyq+LphJf/evs7z34JQoX1qzqg3SkFtesjs9s/qMykwpTaDe4Fr31FMCdyuZEebL51fGBjUZT9XmW0hBKPedaQdGWWpYYRQ1wSIBEt20aWhu1JfdKrr498wjbdLcCOqQ4cS07UcroH7wRPQp/NjYKMD3xYvPFvCUg/BuGK8cenH+aH3Uv9AjYS5CyAYYbNbRN+SzdOaQohUzQv anakin@r2d2"
}
