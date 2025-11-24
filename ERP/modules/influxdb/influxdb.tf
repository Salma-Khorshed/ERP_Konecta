resource "aws_instance" "influxdb" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.sg_id]

  tags = {
    Name        = "${var.project_name}-${var.environment}-influxdb"
  }
}

