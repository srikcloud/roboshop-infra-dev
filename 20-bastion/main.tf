resource "aws_instance" "bastion" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = local.bastion_sg_id
  subnet_id = 
  tags = {
    Name = "HelloWorld"
  }
}