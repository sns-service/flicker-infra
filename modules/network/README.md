# Network Module

VPC, Subnets, IGW, NAT Gateway, Route Tables, Security Groups.

## Architecture
## Usage

```hcl
module "network" {
  source = "../../modules/network"

  project_name = "flicker"
  vpc_cidr     = "10.0.0.0/16"
  azs          = ["ap-northeast-2a", "ap-northeast-2c"]

  single_nat_gateway = true  # 비용 절감
}
```

## Cost Note

NAT Gateway: ~$32/month per gateway + data transfer.
Set `enable_nat_gateway = false` for dev environments without external network needs.