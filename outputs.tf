output "aws_test_ext_ip" {
  value = aws_instance.aws_test_ec2.public_ip
}

output "aws_test_int_ip" {
  value = aws_instance.aws_test_ec2.private_ip
}