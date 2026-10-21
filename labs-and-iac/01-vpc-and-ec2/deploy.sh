#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Configuration Variables
AWS_REGION="us-east-1"
VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.1.0/24"
TAG_NAME="CloudPractitioner-Lab01"

echo "======================================================"
echo "Starting Lab 01 Infrastructure Deployment (VPC + EC2)"
echo "Region: $AWS_REGION"
echo "======================================================"

# 1. Create Custom VPC
echo "[1/7] Creating Custom VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block "$VPC_CIDR" --region "$AWS_REGION" --query 'Vpc.VpcId' --output text)
aws ec2 create-tags --resources "$VPC_ID" --tags Key=Name,Value="$TAG_NAME-VPC" --region "$AWS_REGION"
aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-hostnames "{\"Value\":true}" --region "$AWS_REGION"
echo " -> VPC Created: $VPC_ID"

# 2. Create and Attach Internet Gateway
echo "[2/7] Creating and attaching Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway --region "$AWS_REGION" --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 create-tags --resources "$IGW_ID" --tags Key=Name,Value="$TAG_NAME-IGW" --region "$AWS_REGION"
aws ec2 attach-internet-gateway --vpc-id "$VPC_ID" --internet-gateway-id "$IGW_ID" --region "$AWS_REGION"
echo " -> Internet Gateway Created & Attached: $IGW_ID"

# 3. Create Public Subnet
echo "[3/7] Creating Public Subnet..."
SUBNET_ID=$(aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block "$SUBNET_CIDR" --region "$AWS_REGION" --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources "$SUBNET_ID" --tags Key=Name,Value="$TAG_NAME-PublicSubnet" --region "$AWS_REGION"
aws ec2 modify-subnet-attribute --subnet-id "$SUBNET_ID" --map-public-ip-on-launch --region "$AWS_REGION"
echo " -> Public Subnet Created: $SUBNET_ID"

# 4. Create Custom Route Table and Route to Internet
echo "[4/7] Setting up Route Table and Internet Route..."
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id "$VPC_ID" --region "$AWS_REGION" --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-tags --resources "$ROUTE_TABLE_ID" --tags Key=Name,Value="$TAG_NAME-RouteTable" --region "$AWS_REGION"
aws ec2 create-route --route-table-id "$ROUTE_TABLE_ID" --destination-cidr-block "0.0.0.0/0" --gateway-id "$IGW_ID" --region "$AWS_REGION" > /dev/null
aws ec2 associate-route-table --subnet-id "$SUBNET_ID" --route-table-id "$ROUTE_TABLE_ID" --region "$AWS_REGION" > /dev/null
echo " -> Route Table Associated: $ROUTE_TABLE_ID"

# 5. Create Security Group
echo "[5/7] Creating Security Group (Allow SSH & HTTP)..."
SG_ID=$(aws ec2 create-security-group --group-name "$TAG_NAME-SG" --description "Security group for Lab 01 web server" --vpc-id "$VPC_ID" --region "$AWS_REGION" --query 'GroupId' --output text)
aws ec2 create-tags --resources "$SG_ID" --tags Key=Name,Value="$TAG_NAME-SG" --region "$AWS_REGION"

# Authorize SSH (Port 22) and HTTP (Port 80)
aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --protocol tcp --port 22 --cidr "0.0.0.0/0" --region "$AWS_REGION" > /dev/null
aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --protocol tcp --port 80 --cidr "0.0.0.0/0" --region "$AWS_REGION" > /dev/null
echo " -> Security Group Created: $SG_ID"

# 6. Fetch Latest Amazon Linux 2023 AMI ID
echo "[6/7] Fetching latest Amazon Linux 2023 AMI ID..."
AMI_ID=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --region "$AWS_REGION" --query 'Parameters[0].Value' --output text)
echo " -> AMI ID: $AMI_ID"

# 7. Launch EC2 Instance with User Data (Apache Web Server)
echo "[7/7] Launching EC2 Instance..."
USER_DATA_SCRIPT=$(cat <<'EOF'
#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>AWS Cloud Practitioner - Lab 01 Successful!</h1><p>Running on Amazon EC2 & Custom VPC</p>" > /var/www/html/index.html
EOF
)

INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 1 \
    --instance-type "t2.micro" \
    --key-name "" \
    --security-group-ids "$SG_ID" \
    --subnet-id "$SUBNET_ID" \
    --user-data "$USER_DATA_SCRIPT" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME-WebServer}]" \
    --region "$AWS_REGION" \
    --query 'Instances[0].InstanceId' \
    --output text)

echo " -> EC2 Instance Launched: $INSTANCE_ID"
echo "Waiting for instance to enter running state..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID" --region "$AWS_REGION"

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --region "$AWS_REGION" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo "======================================================"
echo "Deployment Completed Successfully!"
echo "------------------------------------------------------"
echo "VPC ID:       $VPC_ID"
echo "Subnet ID:    $SUBNET_ID"
echo "Instance ID:  $INSTANCE_ID"
echo "Public IP:    $PUBLIC_IP"
echo "Test URL:     http://$PUBLIC_IP"
echo "======================================================"