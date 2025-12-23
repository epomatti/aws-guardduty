#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

apt update && apt upgrade -y

# CloudWatch Agent
# Installation
PLATFORM=arm64
REGION=us-east-2
EXTENSION=deb
wget "https://amazoncloudwatch-agent-$REGION.s3.$REGION.amazonaws.com/ubuntu/$PLATFORM/latest/amazon-cloudwatch-agent.$EXTENSION"
dpkg -i -E "./amazon-cloudwatch-agent.$EXTENSION"

# Configuration
SSM_PARAMETER_NAME=AmazonCloudWatch-linux
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c "ssm:$SSM_PARAMETER_NAME"

# Ubuntu Pro
apt install -y ubuntu-advantage-tools
pro enable usg
apt install -y usg
