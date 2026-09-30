# AWS Shared Responsibility Model & Security Principles

## 1. Executive Summary

Security and Compliance in Amazon Web Services (AWS) is a shared responsibility between AWS and the customer. This model simplifies operational burden for organizations because AWS operates, manages, and controls the components from the host operating system and virtualization layer down to the physical security of the facilities.

Understanding the exact division of responsibility prevents critical security gaps in production deployments and is a key topic for both technical interviews and cloud compliance audits.

---

## 2. The Core Division: Security "OF" vs. Security "IN" the Cloud

```
+-------------------------------------------------------------------------+
|                  CUSTOMER RESPONSIBILITY ("IN" the Cloud)               |
|                                                                         |
|  - Customer Data & Classification                                       |
|  - IAM (Users, Groups, Roles, MFA, Least Privilege)                     |
|  - Operating System Configuration & Patching (e.g., EC2)                |
|  - Network & Firewall Configuration (Security Groups, NACLs)            |
|  - Client-Side & Server-Side Encryption (KMS, Data at Rest/Transit)    |
+-------------------------------------------------------------------------+
========================= DEMARCATION LINE ================================
+-------------------------------------------------------------------------+
|                    AWS RESPONSIBILITY ("OF" the Cloud)                  |
|                                                                         |
|  - Physical Security of Data Centers (Access Control, Surveillance)     |
|  - Hardware Infrastructure (Servers, Storage, Routers)                  |
|  - Software Infrastructure (Hypervisors, Network Virtualization)        |
|  - Global Infrastructure (Regions, AZs, Edge Locations)                 |
+-------------------------------------------------------------------------+
```

### 2.1 AWS Responsibility: Security "OF" the Cloud

AWS is responsible for protecting the infrastructure that runs all of the services offered in the AWS Cloud.

- **Physical Infrastructure:** Physical data centers, biometric security, CCTV, hardware maintenance, and destruction of end-of-life storage media.
- **Network Infrastructure:** Redundant backbone networks, DDoS mitigation hardware (AWS Shield), and physical network isolation.
- **Virtualization Layer:** Hypervisor maintenance, host patching, and logical isolation of customer tenants.

### 2.2 Customer Responsibility: Security "IN" the Cloud

The customer assumes responsibility for configuring and managing the services they deploy in AWS.

- **Data Management:** Data encryption (in transit and at rest), data classification, and backup retention policies.
- **Identity and Access Management:** IAM policies, credential management, enforcing Multi-Factor Authentication (MFA), and applying the Principle of Least Privilege.
- **Network Traffic:** Configuring Security Groups, Network ACLs, routing tables, and firewall rules.
- **Operating Systems & Applications:** Guest OS security patches, application vulnerabilities, and software dependencies (for IaaS workloads).

---

## 3. Responsibility Matrix Across Service Models

The boundary of responsibility shifts depending on the service deployment model used:

```
+-------------------------------------------------------------------------+
|                           SERVICE CATEGORIES                            |
+-------------------+---------------------------+-------------------------+
| Infrastructure    | Container / Managed       | Abstracted / Serverless |
| (IaaS) e.g., EC2  | (PaaS) e.g., RDS / ECS    | (SaaS) e.g., S3 / DynamoDB|
+-------------------+---------------------------+-------------------------+
| Customer handles  | Customer handles          | Customer handles        |
| OS, Patches, SGs, | Database schemas, IAM,    | Data classification,    |
| Data, and Apps.   | Data, and Network Rules.  | IAM policies, and Data. |
|                   |                           |                         |
| AWS handles       | AWS handles               | AWS handles             |
| Hardware &        | OS patching, DB engine    | Infrastructure, OS,     |
| Hypervisor.       | updates, and Hardware.    | Scaling, and Engine.    |
+-------------------+---------------------------+-------------------------+
```

| Service Model | AWS Services Examples | Customer Responsibility | AWS Responsibility |
|---|---|---|---|
| Infrastructure (IaaS) | EC2, EBS, VPC | Guest OS installation/patching, application security, network rules, IAM policies, and data encryption. | Physical facilities, host hardware, hypervisor, and network infrastructure. |
| Container / Managed (PaaS) | Amazon RDS, Elastic Beanstalk, ECS | Database configuration, schema design, network access rules, IAM, and data encryption. | OS maintenance, database engine installation/patching, backups, and hardware. |
| Abstracted / Serverless (SaaS) | Amazon S3, DynamoDB, Lambda | Data protection, bucket policies, IAM access control, and payload logic. | Underlying OS, execution environment runtime, scaling, hardware, and physical storage. |

---

## 4. Shared Controls

Certain controls apply to both AWS and the customer in a shared capacity:

- **Patch Management:** AWS patches physical hosts and hypervisors; customers patch guest operating systems (EC2) and application dependencies.
- **Configuration Management:** AWS manages the baseline configuration of its infrastructure devices; customers configure their virtual networks, security groups, and cloud resources.
- **Awareness & Training:** AWS trains its employee base on cloud infrastructure security; customers train their internal staff on application security and IAM safe practices.

---

## 5. Recruiter & Technical Interview Takeaways

**Business Impact:** Clear understanding of the Shared Responsibility Model prevents data breaches caused by misconfigured customer settings (e.g., publicly accessible S3 buckets) and optimizes IT operational costs.

**Key Terms for Technical Interviews:** Security OF the Cloud vs Security IN the Cloud, Demarcation Line, IaaS vs PaaS vs Serverless Responsibility, Guest OS Patching, Data at Rest/Transit Encryption.

---
