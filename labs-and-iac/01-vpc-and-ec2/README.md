Lab 01: Custom VPC & Amazon EC2 Deployment via AWS CLI
1. Architecture Overview

This lab provisions a secure, foundational AWS networking environment and launches a web server instance using the AWS CLI, mirroring production-grade cloud architecture principles.

+-----------------------------------------------------------------+
|                       AWS REGION / VPC                          |
|                       CIDR: 10.0.0.0/16                         |
|                                                                 |
|   +---------------------------------------------------------+   |
|   |                    INTERNET GATEWAY                     |   |
|   +----------------------------+----------------------------+   |
|                                |                                |
|                                v                                |
|   +---------------------------------------------------------+   |
|   |           PUBLIC SUBNET (CIDR: 10.0.1.0/24)             |   |
|   |                                                         |   |
|   |   +-------------------------------------------------+   |   |
|   |   |           SECURITY GROUP (SSH & HTTP)           |   |   |
|   |   +-------------------------+-----------------------+   |   |
|   |                             |                           |   |
|   |                             v                           |   |
|   |   +-------------------------------------------------+   |   |
|   |   |             AMAZON EC2 INSTANCE                 |   |   |
|   |   |             (Amazon Linux 2023)                 |   |   |
|   |   +-------------------------------------------------+   |   |
|   +---------------------------------------------------------+   |
+-----------------------------------------------------------------+
2. Infrastructure Components Created
Custom VPC (10.0.0.0/16): Isolated virtual network environment.
Internet Gateway (IGW): Enables bi-directional communication between the VPC and the public internet.
Public Subnet (10.0.1.0/24): Subnet configured with automatic public IPv4 address assignment.
Route Table: Directs outbound internet traffic (0.0.0.0/0) through the Internet Gateway.
Security Group: Stateful firewall allowing inbound traffic on Port 22 (SSH) and Port 80 (HTTP).
Amazon EC2 Instance: Virtual server running Amazon Linux 2023 with an automated user-data script installing an Apache web server.
3. Execution Instructions
3.1 Prerequisites
AWS CLI installed and configured with appropriate IAM credentials (aws configure).
Bash shell environment (Linux, macOS, or WSL on Windows).
3.2 Running the Deployment Script

Navigate to the lab directory:

bash
cd labs-and-iac/01-vpc-and-ec2/

Grant execution permissions to the deployment script:

bash
chmod +x deploy.sh

Execute the script:

bash
./deploy.sh
4. Verification & Cleanup

Verify Web Server: Once the script finishes, copy the output Public IP and paste it into your web browser (http://<PUBLIC_IP>). You should see a welcome page confirming the Apache deployment.

Cleanup Resources: To avoid ongoing charges or resource buildup, delete the resources created in this lab via the AWS Console or by terminating the EC2 instance, deleting the security group, subnet, route table, internet gateway, and VPC.