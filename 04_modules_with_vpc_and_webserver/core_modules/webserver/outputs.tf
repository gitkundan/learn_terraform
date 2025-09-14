output "asg_name" {
  value = aws_autoscaling_group.webserver.name
}

output "instance_sg_id" {
  value = aws_security_group.instance.id
}