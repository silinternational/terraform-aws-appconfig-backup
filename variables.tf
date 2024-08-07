
variable "extension_name" {
  description = "AppConfig Extension name"
  type        = string
  default     = "AppConfig S3 Backup"
}

variable "lambda_function_name" {
  description = "name of the Lambda function"
  type        = string
  default     = "appConfigBackupExtensionLambda"
}

variable "s3_bucket_name" {
  description = "S3 bucket for backup data, used in the extension role"
  type        = string
}

variable "create_s3_bucket" {
  description = "Enable creation of an S3 bucket for storing backup data"
  type        = bool
  default     = false
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention in days. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
  default     = 0
}
