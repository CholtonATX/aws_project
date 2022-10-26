resource "aws_instance" "aws_test_ec2" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.aws_test_ami.id
  key_name               = aws_key_pair.aws_test_key.id
  vpc_security_group_ids = [aws_security_group.aws_test_sg.id]
  subnet_id              = aws_subnet.aws_test_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "aws_test_ec2"
  }

  provisioner "local-exec" {
    command = templatefile("mac-ssh-script.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identityfile = "~/.ssh/aws_test_key"
    })
    // use bash interpreter for mac and linux, Powershell for Windows (default is bash)
    interpreter = ["bash", "-c"]
    // interpreter = ["Powershell", "-Command"]
  }
}






# output "public_ip_address" {
#   value = "${azurerm_linux_virtual_machine.test1-vm.name}: ${data.azurerm_public_ip.test1-vm-ip_data.ip_address}"
# }