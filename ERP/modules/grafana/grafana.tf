resource "aws_instance" "grafana" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name        = "${var.project_name}-grafana"
    Environment = var.environment
  }
}
