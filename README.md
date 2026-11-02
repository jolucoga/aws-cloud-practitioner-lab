# ☁️ AWS Certified Cloud Practitioner (CLF-C02) - Mastery & Portfolio

![AWS Cloud Practitioner](https://img.shields.io/badge/AWS-Certified%20Cloud%20Practitioner%20(CLF--C02)-orange?style=for-the-badge&logo=amazon-aws)
![Status](https://img.shields.io/badge/Status-Active%20Portfolio-success?style=for-the-badge)
![Infrastructure](https://img.shields.io/badge/IaC-AWS%20CLI%20%2F%20Bash-blue?style=for-the-badge&logo=gnu-bash)

## 🎯 Executive Overview

This repository serves as a professional portfolio and comprehensive study guide for the **AWS Certified Cloud Practitioner (CLF-C02)** certification. It combines theoretical documentation aligned with the AWS Well-Architected Framework with automated, repeatable hands-on labs executed via the **AWS CLI**, each one with a matching teardown script.

---

## 📂 Repository Structure

```
aws-cloud-practitioner-lab/
├── README.md                                     # Project portfolio overview
├── docs/                                         # Theoretical Curriculum (CLF-C02 Domains)
│   ├── 01-cloud-concepts/                        # Domain 1: Cloud Concepts & Fundamentals
│   ├── 02-security-and-compliance/               # Domain 2: Security, IAM & Compliance
│   ├── 03-cloud-technology-services/             # Domain 3: Compute, Storage, Networking & Databases
│   └── 04-billing-pricing-and-support/           # Domain 4: Pricing Models, Billing & Support
└── labs-and-iac/                                 # Practical Infrastructure as Code (IaC)
    ├── 01-vpc-and-ec2/                           # Lab 01: Custom VPC, Subnets, IGW & Apache Web Server (deploy + destroy)
    └── 02-s3-iam-and-security/                   # Lab 02: Secure S3 Buckets, Lifecycle & IAM Policies [Planned]
```

---

## 📚 Theoretical Documentation (CLF-C02 Domains)

The four exam domains are documented inside the `docs/` directory. Domain 3 currently covers networking, compute, storage and databases; the remaining services are listed in the [Roadmap](#-roadmap):

| Domain | Focus Area | Key Covered Topics |
|---|---|---|
| **Domain 1** | Cloud Concepts | Cloud value proposition, Economies of scale, Global infrastructure (Regions, AZs, Edge), 6 Rs of migration. |
| **Domain 2** | Security & Compliance | Shared Responsibility Model, IAM (Users, Groups, Roles, JSON Policies, MFA), WAF, Shield, KMS, CloudTrail, GuardDuty. |
| **Domain 3** | Technology Services | VPC networking, Security Groups vs NACLs, EC2 purchasing options, S3 storage classes, EBS vs EFS, RDS, Aurora, DynamoDB. |
| **Domain 4** | Billing & Support | Pricing models, Ingress vs Egress data transfer, Cost Explorer, AWS Budgets, Organizations, Support Plans, Trusted Advisor. |

---

## 🛠️ Practical Labs & Infrastructure as Code (IaC)

Rather than relying solely on the AWS Management Console, this project emphasizes automated, repeatable deployments using Bash and AWS CLI. Every lab ships with a `destroy.sh` so nothing is left billing.

### Lab 01: Custom VPC & Amazon EC2 Deployment

**Location:** `labs-and-iac/01-vpc-and-ec2/`

- **Architecture:** Custom VPC (10.0.0.0/16), Internet Gateway, Public Subnet, Custom Route Table, and a Security Group allowing HTTP (80) only. SSH is opt-in and restricted to a single CIDR.
- **Compute:** Launches an Amazon Linux 2023 EC2 instance with an automated user-data script installing Apache. IMDSv2 is required and the root volume is encrypted.
- **Execution:** `deploy.sh` provisions (and rolls back by itself on failure); `destroy.sh` removes everything.
- **Details:** see the [Lab 01 README](labs-and-iac/01-vpc-and-ec2/README.md).

### Lab 02: Secure Object Storage & IAM Governance

**Location:** `labs-and-iac/02-s3-iam-and-security/`

- **Status:** planned.
- **Scope:** an encrypted Amazon S3 bucket with strict Public Access Blocks and Lifecycle Transition Rules (S3 Standard to Glacier), plus dedicated IAM Groups and custom JSON policies that enforce the Principle of Least Privilege.

---

## 🚀 Getting Started & Execution

### Prerequisites

- AWS CLI installed and configured with appropriate administrative credentials (`aws configure`).
- AWS CLI **v2**.
- Bash environment (Linux, macOS, or WSL / Git Bash on Windows).

### Running Lab 01

```bash
cd labs-and-iac/01-vpc-and-ec2/
chmod +x deploy.sh
./deploy.sh
# ... verify the web page ...
./destroy.sh
```

---

## 🗺️ Roadmap

- [ ] Lab 02: S3, lifecycle rules and IAM least privilege.
- [ ] Domain 3 documentation for the remaining services: Elastic Load Balancing and Auto Scaling, serverless and containers (Lambda, ECS, EKS), monitoring (CloudWatch, CloudTrail), integration (SQS, SNS) and infrastructure as code (CloudFormation).
- [ ] Screenshots of each lab run as evidence.

---

## 💡 Core Architectural Principles

- **Principle of Least Privilege (PoLP):** Strict access control policies assigned via IAM roles and groups.
- **Cost Optimization:** Strategic use of EC2 pricing models (Spot/Reserved) and S3 lifecycle storage classes.
- **High Availability & Fault Tolerance:** Multi-AZ design patterns and automated backup architectures.

Developed as part of an advanced cloud engineering and AWS certification mastery path.