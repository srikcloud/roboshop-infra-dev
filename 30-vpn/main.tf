resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("C:\\devops\\daws-84s\\repos\\roboshop-infra-dev\\openvpn.pub") #path of the pubkey which I newly generated via ssh-keygen <filename>, for mac or linux use /
}


resource "aws_instance" "vpn" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id = local.public_subnet_id
 #key_name = "daws-84s" # if already having existing key use this 
  key_name = aws_key_pair.openvpn.key_name # if already having existing key comment this
  user_data = file("openvpn.sh")

  tags = merge (
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-vpn"
    }
    )
}