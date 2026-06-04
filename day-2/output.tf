output "instance_public_ip" {
    value = aws_instance.name.public_ip
  description = "The public IP address of the EC2 instance." 
}

output "instance_private_ip" {
    value = aws_instance.name.private_ip
  description = "The private IP address of the EC2 instance." 
}

output "subnet_id" {
    value = aws_instance.name.subnet_id
  description = "The subnet ID of the EC2 instance." 
}