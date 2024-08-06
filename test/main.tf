module "simple" {
  source = "../"

  s3_bucket_name = "my_bucket"
}

module "full" {
  source = "../"

  s3_bucket_name        = "my_bucket"
  lambda_function_name  = "function"
  create_s3_bucket      = true
  log_retention_in_days = 30
  extension_name        = "backup"
}
