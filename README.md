# AWS GuardDuty

Threat detection with AWS GuardDuty.

Events are sourced from RDS Aurora, S3 and EC2.

> 👉 GuardDuty will be enabled by Terraform

```sh
terraform plan
terraform apply -auto-approve
```

The configuration will also provision IP sets in `TXT` format for:

- Trusted IPs
- Threat IPs
