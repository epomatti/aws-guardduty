output "ec2_instance_arn" {
  value = module.ec2-instance.arn
}

output "ssm_start_session_command" {
  value = "aws ssm start-session --target ${module.ec2-instance.id}"
}
