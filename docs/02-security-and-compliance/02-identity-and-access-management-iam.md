# AWS Identity and Access Management (IAM) & Security Best Practices

## 1. Executive Summary

**AWS Identity and Access Management (IAM)** is a web service that helps administrators securely control access to AWS resources. IAM provides fine-grained access control across all AWS infrastructure by managing authentication (who can log in) and authorization (what permissions they have).

Mastering IAM is fundamental for enforcing the **Principle of Least Privilege**, preventing unauthorized access, and securing enterprise architectures against credential exposure.

---

## 2. Core Components of IAM

IAM architecture is built around five core identities and constructs:

```
+-------------------------------------------------------------------------+
|                               IAM DOMAIN                                |
|                                                                         |
|  +--------------------+        +-------------------+                    |
|  |     IAM USER       | -----> |     IAM GROUP     |                    |
|  | (Human / App Identity)      | (Collection of    |                    |
|  +---------+----------+        |   IAM Users)      |                    |
|            |                   +---------+---------+                    |
|            |                             |                              |
|            v                             v                              |
|  +-------------------------------------------------+                    |
|  |                    IAM POLICY                   |                    |
|  |     (JSON Document Defining Permissions)        |                    |
|  +-------------------------------------------------+                    |
|                                                                         |
|  +-------------------------------------------------+                    |
|  |                    IAM ROLE                     |                    |
|  |   (Temporary Credentials for EC2, Lambda, etc.) |                    |
|  +-------------------------------------------------+                    |
+-------------------------------------------------------------------------+
```

### 2.1 IAM Entities Breakdown

| Identity / Component | Description | Best Practice Use Case |
|---|---|---|
| AWS Account Root User | The identity created when the AWS account is first opened. Has complete, unrestricted access to all resources and billing. | Lock away immediately! Enable MFA and only use for account closure or changing billing plans. |
| IAM User | An entity created within AWS that represents a specific person or application interacting with resources. | Create individual users for team members requiring persistent CLI/Console access. |
| IAM Group | A collection of IAM users. Permissions attached to a group apply automatically to all member users. | Group users by operational role (e.g., Admins, Developers, Auditors). |
| IAM Role | An identity with specific permissions that can be assumed temporarily by users, applications, or AWS services (e.g., EC2, Lambda). | Assign permissions to applications running on AWS without embedding long-term API access keys. |
| IAM Policy | A JSON document that defines explicit permissions (Allows or Denies) for actions, resources, and conditions. | Attach policies to Groups or Roles rather than directly to individual Users. |

---

## 3. Structure of an IAM Policy (JSON)

IAM policy documents determine authorization using standard JSON structures.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3ReadOnlyAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-company-backup-bucket",
        "arn:aws:s3:::my-company-backup-bucket/*"
      ]
    }
  ]
}
```

### Key Elements of an IAM Statement

- **Effect:** Specifies whether the statement results in an "Allow" or explicit "Deny". (Note: An explicit Deny always overrides an Allow).
- **Action:** List of specific API operations allowed or denied (e.g., s3:GetObject, ec2:RunInstances).
- **Resource:** Specifies the exact AWS resource(s) impacted using Amazon Resource Names (ARNs).
- **Condition (Optional):** Controls when the policy is in effect (e.g., require MFA, restrict to specific IP ranges).

---

## 4. Fundamental IAM Security Best Practices

To maintain a strong security posture in AWS, engineers must adhere to the following baseline rules:

```
+-------------------------------------------------------------------------+
|                       IAM SECURITY GOLDEN RULES                         |
+-------------------------------------------------------------------------+
| 1. Lock Down the Root Account (MFA + No Daily Use)                      |
| 2. Enforce the Principle of Least Privilege                             |
| 3. Use IAM Roles for AWS Compute Services (No Hardcoded Access Keys)    |
| 4. Require Multi-Factor Authentication (MFA) for All Interactive Users  |
| 5. Rotate Credentials & Access Keys Regularly                           |
| 6. Enforce Strong Password Policies via IAM Account Settings            |
+-------------------------------------------------------------------------+
```

**Protect the Root User:** Enable hardware or virtual MFA on the root account immediately. Do not generate API access keys for root.

**Principle of Least Privilege:** Grant only the exact permissions required to perform a specific task—nothing more.

**Use IAM Roles for Applications:** Never hardcode long-term credentials (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY) inside application code or EC2 instances. Use IAM Roles with temporary credentials.

**Enforce MFA:** Mandate Multi-Factor Authentication for all human users accessing the AWS Management Console.

**Grant Permissions Using Groups:** Attach policies to Groups rather than individual IAM users to maintain clean, scalable administration.

---

## 5. Recruiter & Technical Interview Takeaways

**Business Value:** Proper IAM configuration prevents credential leakage, mitigates ransomware risks, and fulfills regulatory compliance requirements (e.g., SOC2, ISO 27001).

**Key Terms for Technical Interviews:** Principle of Least Privilege, Authentication vs Authorization, IAM Policies (JSON), IAM Roles vs Users, Root Account Hardening, MFA, Explicit Deny Overrides Allow.

---