# AWS AppConfig backup to S3

Terraform module to create and manage an AppConfig custom extension to copy a Configuration Profile
to an S3 bucket for every deployment.

Includes:

* AppConfig Extension and Role
* Lambda Function and Role
* CloudWatch log group
* (optional) S3 Bucket

## Using the extension

After the extension has been created by Terraform, it must be applied to an AppConfig Application,
Configuration Profile, or Environment. To do this in the AWS Console, follow these instructions:

- Open AppConfig
- Choose "Extensions" in the side menu
- Choose the "AppConfig S3 Backup" extension (or your custom extension name, as applicable)
- Click the "Add to resource" button
- Choose the resource type and specific resource you wish to associate with the extension
- Enter the backup bucket name in the S3_BUCKET parameter
- Click the "Create association to resource" button


## More info

More information is available at the [Terraform Registry](https://registry.terraform.io/modules/silinternational/appconfig-backup/aws/latest)
