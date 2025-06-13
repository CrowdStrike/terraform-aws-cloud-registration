output "reader_role_arn" {
  value       = aws_iam_role.this[*].arn
  description = "The reader role ARN used for asset inventory"
}
