# Terraform Examples

This repository contains examples of Terraform configurations for various cloud services.

## Directory Structure

- **awt_iot/main.tf**: Terraform configuration for AWS IoT.
- **s3/main.tf**: Terraform configuration for an Amazon S3 bucket.
- **EC2/main.tf**: Terraform configuration for an Amazon EC2 instance.

## How to Use

1. **Initial Setup**: Before getting started, make sure you have Terraform installed. Then, initialize the working directory.

```bash
   terraform init
```

2. Apply Configuration: Run the following command to apply the configuration and create the resources.

```bash
   terraform apply  or  terraform apply -auto-approve
```

3. Destroy Resources: If you want to delete the created resources, you can run the following command.

```bash
   terraform destroy or terraform destroy -auto-approve
```

## Terraform Commands

## `terraform plan`

The `terraform plan` command is used to preview the changes that Terraform will make to the infrastructure. It does not apply the changes but shows a detailed view of what will be created, modified, or destroyed.

```
terraform plan
```

## `terraform show`

The `terraform show` command is used to display human-readable output of the current state or the changes planned by Terraform.

```
terraform show
```
## `terraform output`

The `terraform output` command is used to display the values of output variables defined in your Terraform configuration.

```
terraform output
```
