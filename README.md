# AWS GuardDuty

Threat detection with AWS GuardDuty.

Events are sourced from RDS Aurora, S3 and EC2.

> 💡 GuardDuty will be enabled by Terraform

```sh
terraform plan
terraform apply -auto-approve
```

The configuration will also provision IP sets in `TXT` format for:

- Trusted IPs
- Threat IPs

## 🟧 EC2 Malware Scan

Execute an on-demand scan on an instance:

```sh
aws guardduty start-malware-scan \
    --resource-arn 'arn:aws:ec2:us-east-2:000000000000:instance/i-00000000000000000'
```

<img src=".assets/scan.png" width=350/>

## ℹ️ Supported services

Personal note: as of today, these are the [supported services][1]:

> GuardDuty is an intelligent threat detection service that continuously monitors your AWS accounts, Amazon Elastic Compute Cloud (Amazon EC2) instances, AWS Lambda functions, Amazon Elastic Kubernetes Service (Amazon EKS) clusters, Amazon Aurora login activity, and data stored in Amazon Simple Storage Service (Amazon S3) for malicious activity.

- AWS Accounts
- EC2 Instances
- Lambda Functions
- EKS Clusters
- RDS Aurora login activity
- S3

Some services are [not supported][2]:

> GuardDuty Malware Protection doesn't support Fargate with either Amazon EKS or Amazon ECS.

## Runtime Monitoring

The VPC endpoint `com.amazonaws.us-east-2.guardduty-data` will be created by Terraform. GuardDuty service states it does not charge for these endpoints.

Let GuardDuty use [automated][3] agent configuration, or install it manually.

<img src=".assets/guardduty-runtimemonitoring-enabled.png" width=350/>

<img src=".assets/guardduty-ec2-enabled.png" width=350/>

As of today, it looks like Ubuntu is not supported at the moment:

> failed to find platform: no manifest found for platform: ubuntu, version 22.04, architecture arm64

Example of Amazon Linux instance covered by GuardDuty:

<img src=".assets/guardduty-coverage.png" />



[1]: https://aws.amazon.com/guardduty/faqs/
[2]: https://docs.aws.amazon.com/guardduty/latest/ug/malware-protection.html
[3]: https://docs.aws.amazon.com/guardduty/latest/ug/how-runtime-monitoring-works-ec2.html#use-automated-agent-config-ec2
