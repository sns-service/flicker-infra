# ECR Module

Amazon ECR (Elastic Container Registry) repository with lifecycle policy.

## Usage

```hcl
module "ecr" {
  source = "../../modules/ecr"

  name = "flicker"

  scan_on_push           = true
  lifecycle_policy_count = 10
}
```

## Outputs

- `repository_url`: ECR URL (예: `123.dkr.ecr.ap-northeast-2.amazonaws.com/flicker`)
- `repository_arn`: ARN for IAM policies
- `repository_name`: Bare repository name