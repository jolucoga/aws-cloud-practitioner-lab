# ☁️ AWS Certified Cloud Practitioner (CLF-C02) - Mastery & Portfolio

![AWS Cloud Practitioner](https://img.shields.io/badge/AWS-Certified%20Cloud%20Practitioner%20(CLF--C02)-orange?style=for-the-badge&logo=amazon-aws)
![Status](https://img.shields.io/badge/Status-Active%20Portfolio-success?style=for-the-badge)
![Infrastructure](https://img.shields.io/badge/IaC-AWS%20CLI%20%2F%20Bash-blue?style=for-the-badge&logo=gnu-bash)

## 🎯 Executive Overview

This repository serves as a professional portfolio and comprehensive study guide for the **AWS Certified Cloud Practitioner (CLF-C02)** certification. It combines rigorous theoretical documentation—aligned with enterprise architecture standards and the AWS Well-Architected Framework—with automated, production-grade practical labs executed via the **AWS CLI**.

---

## 📂 Repository Structure

```
aws-cloud-practitioner/
├── README.md                                     # Project portfolio overview
├── docs/                                         # Theoretical Curriculum (CLF-C02 Domains)
│   ├── 01-cloud-concepts/                        # Domain 1: Cloud Concepts & Fundamentals
│   ├── 02-security-and-compliance/               # Domain 2: Security, IAM & Compliance
│   ├── 03-cloud-technology-services/             # Domain 3: Compute, Storage, Networking & Databases
│   └── 04-billing-pricing-and-support/           # Domain 4: Pricing Models, Billing & Support
└── labs-and-iac/                                 # Practical Infrastructure as Code (IaC)
    ├── 01-vpc-and-ec2/                           # Lab 01: Custom VPC, Subnets, IGW & Apache Web Server
    └── 02-s3-iam-and-security/                   # Lab 02: Secure S3 Buckets, Lifecycle & IAM Policies [Active]
```

---

## 📚 Theoretical Documentation (CLF-C02 Domains)

All core domains required for the official certification exam are fully documented inside the `docs/` directory:

| Domain | Focus Area | Key Covered Topics |
|---|---|---|
| **Domain 1** | Cloud Concepts | Cloud value proposition, Economies of scale, Global infrastructure (Regions, AZs, Edge), 6 Rs of migration. |
| **Domain 2** | Security & Compliance | Shared Responsibility Model, IAM (Users, Groups, Roles, JSON Policies, MFA), WAF, Shield, KMS, CloudTrail, GuardDuty. |
| **Domain 3** | Technology Services | EC2 purchasing options, Lambda, ECS/EKS, S3 storage classes, EBS vs EFS, RDS, Aurora, DynamoDB, VPC networking. |
| **Domain 4** | Billing & Support | Pricing models, Ingress vs Egress data transfer, Cost Explorer, AWS Budgets, Organizations, Support Plans, Trusted Advisor. |

---

## 🛠️ Practical Labs & Infrastructure as Code (IaC)

Rather than relying solely on the AWS Management Console, this project emphasizes automated, repeatable deployments using Bash and AWS CLI.

### Lab 01: Custom VPC & Amazon EC2 Deployment

**Location:** `labs-and-iac/01-vpc-and-ec2/`

- **Architecture:** Custom VPC (10.0.0.0/16), Internet Gateway, Public Subnet, Custom Route Table, and a Security Group allowing SSH (22) and HTTP (80).
- **Compute:** Launches an Amazon Linux 2023 EC2 instance with an automated user-data script installing and configuring an Apache web server.
- **Execution:** Automated via `deploy.sh`.

### Lab 02: Secure Object Storage & IAM Governance

**Location:** `labs-and-iac/02-s3-iam-and-security/`

- **Architecture:** Provisioning of an encrypted Amazon S3 bucket with strict Public Access Blocks and automated Lifecycle Transition Rules (S3 Standard to Glacier).
- **Security:** Enforces the Principle of Least Privilege via dedicated IAM Groups and custom JSON access policies.

---

## 🚀 Getting Started & Execution

### Prerequisites

- AWS CLI installed and configured with appropriate administrative credentials (`aws configure`).
- Bash environment (Linux, macOS, or WSL on Windows).

### Running Lab 01

```bash
cd labs-and-iac/01-vpc-and-ec2/
chmod +x deploy.sh
./deploy.sh
```

---

## 💡 Core Architectural Principles

- **Principle of Least Privilege (PoLP):** Strict access control policies assigned via IAM roles and groups.
- **Cost Optimization:** Strategic use of EC2 pricing models (Spot/Reserved) and S3 lifecycle storage classes.
- **High Availability & Fault Tolerance:** Multi-AZ design patterns and automated backup architectures.

Developed as part of an advanced cloud engineering and AWS certification mastery path.