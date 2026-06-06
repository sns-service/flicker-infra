# Flicker Infrastructure

Flicker의 인프라를 Terraform으로 관리.

## 구조

- `environments/prod/`: 운영 환경
- `modules/`: 재사용 가능한 모듈

## 사용

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

## Backend

State는 S3 `flicker-tfstate-637423170275`에 저장. 동시 실행 방지를 위해 DynamoDB `flicker-tfstate-lock` 사용.