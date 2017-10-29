# tf-aws-serverless-blog-boilerplate

## Architecture

- S3
- CloudFront
- ACM
- Route53

## Installation

### Edit variables

```
$ cp -p terraform.tfvars{.sample,}

$ vi terraform.tfvars
```

`terraform.tfvars`

```
apex_domain = "example.com"
site_domain = "www.example.com"

access_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
```

### Create S3 Bucket

```
# for Site contents
$ aws s3 mb s3://www.example.com

# for Terraform state
$ aws s3 mb s3://example.terraform
```

### Create DynamoDB

```
$ aws dynamodb create-table \
    --table-name TerraformLockState \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
```

### Set remote state

```
$ terraform remote config \
    -backend=s3 \
    -backend-config="bucket=example.terraform" \
    -backend-config="key=example.com/terraform.tfstate" \
    -backend-config="region=ap-northeast-1"
```

### Apply

```
$ terraform plan
$ terraform apply
```
