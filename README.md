# ☁️ AWS Cloud Practitioner (CLF-C02) — Applied Portfolio & Architecture Labs

[![AWS Certified Cloud Practitioner](https://img.shields.io/badge/AWS-Cloud%20Practitioner-orange?style=for-the-badge&logo=amazon-aws)](https://aws.amazon.com/certification/certified-cloud-practitioner/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![IaC: Terraform / AWS CLI](https://img.shields.io/badge/IaC-AWS%20CLI%20%7C%20Terraform-blue?style=for-the-badge&logo=terraform)](https://www.terraform.io/)

Welcome to my **AWS Cloud Practitioner Portfolio Repository**. This repository bridges theoretical knowledge from the [AWS Certified Cloud Practitioner (CLF-C02)](https://www.udemy.com/course/certified-cloud-practitioner-aws/) certification with **real-world implementation**, focusing on infrastructure design, security best practices, cost optimization, and hands-on labs.

---

## 🎯 Executive Summary & Objectives

The goal of this repository is to demonstrate practical competency in cloud computing using the **AWS Well-Architected Framework**. Rather than just taking notes, each section provides:
* **Architecture Diagrams** built with official AWS icon sets.
* **Hands-on Implementation Labs** using AWS CLI, CloudFormation, and Terraform.
* **Security & Governance Models** adhering to the *Principle of Least Privilege*.
* **Cost Optimization Strategies** analyzing real-world pricing models.

---

## 📂 Repository Structure

```text
aws-cloud-practitioner-portfolio/
├── README.md                      # Primary project overview and portfolio guide
├── docs/                          # Core Domain Guides (CLF-C02 Syllabus)
│   ├── 01-cloud-concepts.md       # Value proposition, elasticity, economics
│   ├── 02-security-compliance.md  # Shared Responsibility, IAM, KMS, Shield
│   ├── 03-cloud-technology.md     # Compute, Storage, Networking, Databases
│   └── 04-billing-pricing.md      # AWS Budgets, Cost Explorer, Organizations
├── architecture-diagrams/         # Visual representations & design patterns
│   ├── 01-vpc-isolation.png
│   └── 02-serverless-web-app.png
├── labs-and-iac/                  # Hands-on labs and Infrastructure as Code
│   ├── lab-01-vpc-and-ec2/        # Custom VPC, public/private subnets, IGW
│   ├── lab-02-s3-cloudfront-cdn/  # Static web hosting with OAC security
│   ├── lab-03-iam-least-privilege/# Granular IAM roles and policy creation
│   └── lab-04-cost-budgeting/     # Automated budget alerts and CloudWatch
└── scripts/                       # Automation and helper tools
    └── aws-inventory-audit.sh     # Script to list active resources across regions
```

---

## 🧪 Hands-On Labs Matrix

| Lab | AWS Services | Core Architectural Concept | Deployment Method |
| :--- | :--- | :--- | :--- |
| **[Lab 01](./labs-and-iac/lab-01-vpc-and-ec2/)** | VPC, EC2, IGW, Security Groups | Network isolation, subnets, and secure access | AWS CLI / Terraform |
| **[Lab 02](./labs-and-iac/lab-02-s3-cloudfront-cdn/)** | S3, CloudFront, Route 53 | High-availability static hosting & edge delivery | CloudFormation |
| **[Lab 03](./labs-and-iac/lab-03-iam-least-privilege/)** | IAM Roles, Policies, STS | Zero-Trust & Least-Privilege access control | JSON Policy / CLI |
| **[Lab 04](./labs-and-iac/lab-04-cost-budgeting/)** | AWS Budgets, CloudWatch, SNS | Cost anomaly detection and proactive alerts | AWS Console / CLI |

---

## 🏛️ Key Architectural Patterns Included

### 1. High-Availability Multi-AZ Web Architecture
Demonstrates fault tolerance using an Application Load Balancer (ALB) across multiple Availability Zones with Auto Scaling groups.

```text
[ Internet ] ──> [ ALB ] ──┬──> [ Public Subnet AZ-A (EC2) ]
                            └──> [ Public Subnet AZ-B (EC2) ]
                                            │
                                            ▼
                               [ Private Subnet (RDS Multi-AZ) ]
```

### 2. Secure Content Delivery (S3 + CloudFront OAC)
Ensures Amazon S3 buckets remain completely private while delivering global static content through Amazon CloudFront edge locations using Origin Access Control (OAC).

---

## 📚 Exam Domain Breakdown & Notes

Detailed study material and trade-off analyses aligned with the official exam domains:

1. **[Domain 1: Cloud Concepts](./docs/01-cloud-concepts.md)** — Cloud economics, trade-offs (CapEx vs. OpEx), and the 6 Pillars of the Well-Architected Framework.
2. **[Domain 2: Security & Compliance](./docs/02-security-compliance.md)** — AWS Shared Responsibility Model, compliance resources (AWS Artifact), and identity management.
3. **[Domain 3: Cloud Technology & Services](./docs/03-cloud-technology.md)** — Compute (EC2, ECS, Lambda), Storage (S3, EBS, EFS), Databases (RDS, DynamoDB), and Networking (VPC, Route 53).
4. **[Domain 4: Billing, Pricing & Support](./docs/04-billing-pricing.md)** — Pricing calculators, Savings Plans vs. Reserved Instances, Support Plans, and AWS Organizations.

---

## 🚀 How to Replicate these Labs

### Prerequisites
* An active **AWS Account** (Free Tier eligible).
* [AWS CLI v2 installed and configured](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
* Git installed on your local machine.

### Quick Start
1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR-USERNAME/aws-cloud-practitioner-portfolio.git
   cd aws-cloud-practitioner-portfolio
   ```
2. Navigate to any lab directory (e.g., Lab 01):
   ```bash
   cd labs-and-iac/lab-01-vpc-and-ec2
   ```
3. Follow the `README.md` inside the specific lab folder for step-by-step deployment instructions.

---

## 🔒 Security Disclaimer
> ⚠️ **Important:** Never commit sensitive credentials (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `.env` files) to version control. This repository utilizes `.gitignore` and `git-secrets` to prevent credential exposure.

---

## 👤 Author & Contact

**Your Name**
* **LinkedIn:** [linkedin.com/in/joseluiscorona](https://linkedin.com/in/joseluiscorona)
* **GitHub:** [@jolucoga](https://github.com/jolucoga)
* **AWS Certification Status:** *In Progress*

---
## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
