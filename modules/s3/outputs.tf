output "s3_access_instance_profile_name" {
  description = "S3 Access Instance Profile Name"
  value = aws_iam_instance_profile.ec2_s3_access.name
}