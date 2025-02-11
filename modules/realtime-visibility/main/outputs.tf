output "eventbridge_role_arn" {
    value = aws_iam_role.this.arn
    description = "The ARN of the role used for eventbrige rules"
}
