# AWS Networking & Compute Fundamentals (VPC & EC2)

## 1. Executive Summary

This document explains the fundamental networking and compute building blocks of Amazon Web Services. Before deploying virtual servers in AWS, cloud engineers must establish a secure, isolated network topology. Understanding **Amazon VPC** (Virtual Private Cloud) and **Amazon EC2** (Elastic Compute Cloud) is essential for architecting secure, scalable infrastructure.

---

## 2. Amazon VPC: Virtual Networking Core

An **Amazon VPC** is a logically isolated virtual network dedicated to your AWS account. It closely resembles a traditional network that you'd operate in your own data center, with the benefits of using AWS's scalable infrastructure.

```
+-------------------------------------------------------------------------+
| AWS REGION (e.g., us-east-1)                                            |
|                                                                         |
|  +-------------------------------------------------------------------+  |
|  | VPC (10.0.0.0/16)                                                |  |
|  |                                                                   |  |
|  |  +---------------------------+     +---------------------------+  |  |
|  |  | Public Subnet (10.0.1.0/24)|     | Private Subnet(10.0.2.0/24)|  |  |
|  |  | AZ: us-east-1a            |     | AZ: us-east-1b            |  |  |
|  |  |                           |     |                           |  |  |
|  |  |  [EC2 Web Server]         |     |  [EC2 Database Server]    |  |  |
|  |  |  (Public IP: Yes)         |     |  (Public IP: No)          |  |  |
|  |  +-------------+-------------+     +-------------+-------------+  |  |
|  |                |                                 |             |  |
|  |                v                                 v             |  |
|  |        [Internet Gateway]                [NAT Gateway]         |  |
|  +----------------+---------------------------------+----------------+  |
+-------------------|-----------------------------------------------------+
                    v
             (Public Internet)
```

### 2.1 Key VPC Components

| Component | Description | Security / Scope |
|---|---|---|
| CIDR Block | Classless Inter-Domain Routing block defining the IP range for the VPC (e.g., 10.0.0.0/16 provides 65,536 IPs). | Private IP range definition. |
| Public Subnet | A subnet whose route table directs internet-bound traffic to an Internet Gateway (IGW). | Host resources exposed to or accessing the internet (e.g., Web Servers, ALBs). |
| Private Subnet | A subnet whose route table does NOT direct traffic to an Internet Gateway. | Isolates backend systems (e.g., Databases, Internal APIs). |
| Internet Gateway (IGW) | A VPC component that allows communication between instances in your VPC and the internet. | Scalable, redundant VPC edge component. |
| NAT Gateway | Network Address Translation service allowing instances in private subnets to connect to the internet, while preventing external hosts from initiating connections. | Deployed in a Public Subnet; requires an Elastic IP. |
| Route Table | A set of rules (routes) used to determine where network traffic from your subnet or gateway is directed. | Controls network routing per subnet. |

---

## 3. Network Security: Security Groups vs Network ACLs

AWS uses two layers of defense-in-depth security to control network access into and out of VPC resources.

```
Incoming Traffic ---> [ Network ACL (Subnet Level) ] ---> [ Security Group (Instance Level) ] ---> [ EC2 Instance ]
```

### 3.1 Comparison Matrix

| Feature | Security Group (SG) | Network Access Control List (NACL) |
|---|---|---|
| Operates At | Instance / Network Interface Level | Subnet Level |
| Rule Type | Allow rules ONLY (All traffic blocked by default). | Allow AND Deny rules. |
| Statefulness | Stateful: Return traffic is automatically allowed regardless of inbound rules. | Stateless: Return traffic must be explicitly allowed by outbound rules. |
| Evaluation | Evaluates ALL rules before deciding whether to allow traffic. | Evaluates rules in numbered order (lowest number first). |
| Default State | Denies all inbound traffic; allows all outbound traffic. | Default NACL allows all inbound/outbound traffic. |

---

## 4. Amazon EC2: Elastic Compute Cloud

Amazon EC2 provides scalable computing capacity in the AWS Cloud, eliminating the need to invest in hardware upfront.

### 4.1 EC2 Instance Purchasing Options

Choosing the right purchasing strategy is crucial for AWS Cost Optimization:

```
+-----------------------------------------------------------------------+
|                       EC2 PRICING MODELS                              |
+-------------------+-------------------+-------------------------------+
| On-Demand         | Reserved / Savings| Spot Instances                |
| Pay per sec/min   | 1-3 Year Commit   | Bid on Spare Capacity         |
| Highest flexibility| Up to 72% discount| Up to 90% discount            |
| Short, spiky      | Steady-state      | Fault-tolerant, batch jobs    |
| workloads         | workloads         |                               |
+-------------------+-------------------+-------------------------------+
```

**On-Demand Instances:** Pay for compute capacity by the second/minute with no long-term commitment. Best for short-term, unpredictable workloads or testing.

**Reserved Instances (RIs) & Savings Plans:** Commit to a specific instance configuration or hourly spend for a 1 or 3-year term. Offers discounts up to 72% compared to On-Demand.

**Spot Instances:** Request unused EC2 capacity at discounts up to 90%. AWS can reclaim Spot instances with a 2-minute notification. Ideal for stateless, fault-tolerant, or batch processing workloads.

**Dedicated Hosts / Instances:** Physical servers dedicated fully to your account. Used for strict regulatory compliance or socket-based software licensing requirements.

---

## 5. Summary for Lab 01 Readiness

To successfully execute Lab 01, we will build a production-grade VPC setup featuring:

- One VPC with a custom CIDR block (10.0.0.0/16).
- One Public Subnet with an attached Internet Gateway and Route Table.
- One Security Group allowing SSH (Port 22) and HTTP (Port 80) inbound access.
- One EC2 Instance (Linux t3.micro/t2.micro) running a basic web server (Nginx/Apache).

---

## 6. Business Value & Recruiter Summary

**Business Impact:** Proper network design prevents unauthorized access, reduces attack surfaces, and optimizes cost by selecting correct EC2 pricing models.

**Key Terms for Technical Interviews:** VPC, Public/Private Subnets, Internet Gateway, NAT Gateway, Security Groups (Stateful), NACLs (Stateless), On-Demand vs Reserved vs Spot Instances.