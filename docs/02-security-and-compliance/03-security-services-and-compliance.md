# AWS Security Services, Encryption & Compliance Frameworks

## 1. Executive Summary

Beyond identity management, AWS provides a comprehensive suite of security, threat detection, encryption, and compliance services designed to protect workloads from edge-to-cloud. This document covers key AWS security tools, data protection mechanisms (AWS KMS), auditing utilities (CloudTrail vs. CloudWatch), and regulatory compliance frameworks.

---

## 2. Perimeter & Network Security Services

AWS offers native edge services to protect applications against web exploits, malicious bots, and distributed denial-of-service (DDoS) attacks.

```
Incoming Web Traffic
       │
       ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────────┐
│  AWS Shield  │ ──► │   AWS WAF    │ ──► │ AWS Firewall Mgr │
│ (DDoS Protection) │ (Web App Firewall) │ (Central Policy) │
└──────────────┘     └──────────────┘     └──────────────────┘
       │
       ▼
  AWS Resources (CloudFront / ALB / EC2)
```

| Service | Primary Function | Typical Use Case |
|---|---|---|
| AWS Shield (Standard & Advanced) | Managed DDoS protection service. | Standard protects all AWS customers automatically at no extra cost. Advanced provides 24/7 dedicated response team access and cost protection for dynamic scaling. |
| AWS WAF (Web Application Firewall) | Layer 7 firewall filtering malicious web traffic based on customized rules. | Blocks SQL Injection (SQLi), Cross-Site Scripting (XSS), bot scrapers, and specific geographical IP ranges. |
| AWS Network Firewall | Stateful network inspection firewall for VPC-level traffic. | Filters outbound non-HTTP traffic or inspects VPC-to-VPC East-West traffic. |
| AWS Firewall Manager | Central management service for security rules. | Configures WAF rules, Security Groups, and Shield Advanced policies centrally across AWS Organizations. |

---

## 3. Data Protection & Cryptography (AWS KMS)

Security architectures require encrypting data both at rest (on disk) and in transit (across the network).

### 3.1 Key Management Service (KMS) & Encryption Types

- **AWS KMS (Key Management Service):** A managed service that enables creation and management of cryptographic keys (KMS Keys) used to encrypt data across AWS services (S3, EBS, RDS, DynamoDB).
- **AWS CloudHSM:** Dedicated, hardware security module (HSM) appliances under sole customer control for strict regulatory requirements (FIPS 140-2 Level 3).

```
┌─────────────────────────────────────────────────────────────────────────┐
|                            ENCRYPTION TYPES                             |
├───────────────────────────────────┬─────────────────────────────────────┤
| Encryption at Rest                | Encryption in Transit               |
├───────────────────────────────────┼─────────────────────────────────────┤
| Data stored on EBS, S3, RDS.      | Data moving over public/private net.|
| Handled by AWS KMS (AES-256).     | Enforced via TLS/HTTPS protocols.   |
| Customer-Managed Keys (CMK) or    | AWS Certificate Manager (ACM)       |
| AWS-Managed Keys.                 | provisions free SSL/TLS certificates|
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Auditing, Monitoring & Detection Services

Monitoring operational health differs significantly from tracking security API events. Understanding the distinction between CloudWatch and CloudTrail is a classic technical interview topic.

```
┌─────────────────────────────────────────────────────────────────────────┐
|                        MONITORING & DETECTIVE UTILITIES                 |
├───────────────────────────────────┬─────────────────────────────────────┤
| Amazon CloudWatch                 | AWS CloudTrail                      |
├───────────────────────────────────┼─────────────────────────────────────┤
| Focuses on PERFORMANCE & METRICS  | Focuses on GOVERNANCE & API AUDITING|
| - CPU Utilization                 | - "Who made the API call?"          |
| - Memory usage / Network In/Out   | - "What time was the bucket deleted?"|
| - Operational Alarms & Logs       | - User IP, Event Time, Identity     |
└─────────────────────────────────────────────────────────────────────────┘
```

### 4.1 Automated Threat Detection Services

- **Amazon GuardDuty:** Intelligent threat detection service analyzing VPC Flow Logs, CloudTrail Event Logs, and DNS logs using Machine Learning to flag compromised EC2 instances or unauthorized IAM activity.

- **AWS Security Hub:** A security center aggregating alert findings from GuardDuty, Inspector, Macie, and IAM Access Analyzer into a single operational dashboard.

- **Amazon Inspector:** Automated security assessment service that scans EC2 instances and container images for software vulnerabilities and network exposure.

- **Amazon Macie:** Fully managed data security and privacy service using machine learning to discover, classify, and protect sensitive data (PII, credit card numbers) in Amazon S3.

---

## 5. Compliance & Regulatory Artifacts

Organizations running regulated workloads (healthcare, finance, government) must prove regulatory compliance.

```
                    ┌────────────────────────────┐
                    │       AWS ARTIFACT         │
                    └─────────────┬──────────────┘
                                  │
      ┌───────────────────────────┴───────────────────────────┐
      │                                                       │
      ▼                                                       ▼
┌───────────────────────────┐               ┌───────────────────────────┐
│ Compliance Reports        │               │ Compliance Agreements     │
│ (SOC 1/2/3, ISO 27001,    │               │ (Business Associate       │
│  PCI-DSS, HIPAA, GDPR)    │               │  Agreements - BAA)        │
└───────────────────────────┘               └───────────────────────────┘
```

- **AWS Artifact:** A self-service portal providing direct, on-demand access to AWS compliance reports, security certifications, and legal agreements.

- **AWS Config:** Continuously assesses, audits, and evaluates the configuration history of your AWS resources to enforce policy compliance over time.

---

## 6. Recruiter & Technical Interview Takeaways

**Business Impact:** Native security controls protect corporate infrastructure against automated attacks, streamline audit cycles via automated compliance tools, and prevent financial liabilities from data breaches.

**Key Terms for Technical Interviews:** AWS Shield (DDoS) vs WAF (Layer 7), CloudWatch (Metrics/Performance) vs CloudTrail (API History), AWS KMS (Envelope Encryption), GuardDuty (Threat Detection ML), AWS Artifact (Audit Reports).

---