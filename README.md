# AWS AppConfig backup to S3

Terraform module to create and manage an AppConfig custom extension to copy a Configuration Profile
to an S3 bucket for every deployment.

Includes:

* AppConfig Extension and Role
* Lambda Function and Role
* CloudWatch log group
* (optional) S3 Bucket
