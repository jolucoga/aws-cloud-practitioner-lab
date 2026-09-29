# AWS Global Infrastructure & High Availability Design

## 1. Executive Summary

This document covers the fundamental components of the **AWS Global Infrastructure** and the decision frameworks required to deploy resilient, low-latency, and compliant applications globally. Understanding how AWS structures its physical and logical locations is critical for architecting high-availability systems, optimizing costs, and satisfying data residency regulations.

---

## 2. Core Infrastructure Components

AWS physical infrastructure is organized into a hierarchical topology designed to isolate faults and minimize single points of failure.

```
+-----------------------------------------------------------------------+
|                             AWS GLOBAL                                |
|                                                                       |
|  +-----------------------------------------------------------------+  |
|  |                           AWS REGION                            |  |
|  |  (Geographical Area, e.g., us-east-1 N. Virginia)               |  |
|  |                                                                 |  |
|  |  +------------------------+     +----------------------------+  |  |
|  |  | AVAILABILITY ZONE A    |     | AVAILABILITY ZONE B        |  |  |
|  |  | (1+ Isolated Data Ctrs)| <-> | (1+ Isolated Data Centers) |  |  |
|  |  +------------------------+     +----------------------------+  |  |
|  +-----------------------------------------------------------------+  |
|                                                                       |
|  +-----------------------------------------------------------------+  |
|  |                        EDGE NETWORK                             |  |
|  |  +----------------------+      +-----------------------------+  |  |
|  |  | Edge Location (PoP)  |      | Regional Edge Cache         |  |  |
|  |  +----------------------+      +-----------------------------+  |  |
|  +-----------------------------------------------------------------+  |
+-----------------------------------------------------------------------+
```

### 2.1 AWS Regions

**Definition:** A physical geographical location in the world where AWS clusters isolated data centers.

**Key Characteristics:**
- Fully isolated from other Regions to prevent error propagation.
- Consists of a minimum of 3 discrete Availability Zones.
- Connected via a high-speed, redundant private fiber-network backbone.
- Example Naming: us-east-1 (N. Virginia), eu-central-1 (Frankfurt), ap-southeast-1 (Singapore).

### 2.2 Availability Zones (AZs)

**Definition:** One or more discrete data centers with independent power, cooling, and physical security.

**Key Characteristics:**
- Located within a single Region, separated by meaningful physical distance (typically tens of miles) to prevent shared disaster risk (floods, power grid outages).
- Interconnected with high-bandwidth, ultra-low latency networking (<2ms round-trip).
- Represented as logical codes bound to your account (e.g., us-east-1a, us-east-1b).
- Note: AZ names like us-east-1a are randomly mapped per AWS account for load distribution.

### 2.3 Specialized Deployment Targets

| Infrastructure Type | Use Case | Deployment Location |
|---|---|---|
| AWS Local Zones | Applications requiring single-digit millisecond latency (e.g., media editing, real-time gaming). | Major population centers close to users where no full AWS Region exists. |
| AWS Wavelength | Ultra-low latency mobile edge computing applications over 5G networks. | Embedded directly into telecommunication provider data centers at the edge of 5G networks. |
| AWS Outposts | Hybrid cloud scenarios requiring local data processing, low latency, or strict on-premises data residency. | Physical AWS-managed server hardware installed inside on-premises client data centers. |

---

## 3. Edge Network Infrastructure

AWS operates a global network of Points of Presence (PoPs) to deliver content faster to end users around the world.

### 3.1 Edge Locations & Regional Edge Caches

- **Edge Locations:** Smaller endpoints distributed globally that cache content closer to end users. Primarily used by Amazon CloudFront (CDN) and AWS Lambda@Edge.
- **Regional Edge Caches:** Sit between Edge Locations and origin servers. They have larger cache capacities to hold content that isn't requested frequently enough to remain at Edge Locations, reducing requests back to the primary origin server.

### 3.2 Key Services Utilizing Edge Infrastructure

```
                  +--------------------------+
                  |    Global End Users      |
                  +------------+-------------+
                               |
                               v
                  +--------------------------+
                  |   Edge Location (PoP)    |
                  +------------+-------------+
                               |
        +----------------------+----------------------+
        |                      |                      |
        v                      v                      v
+---------------+      +---------------+      +---------------+
| CloudFront    |      | Route 53      |      | AWS Global    |
| Content Cache |      | DNS Resolution|      | Accelerator   |
+---------------+      +---------------+      +---------------+
```

- **Amazon CloudFront:** Global Content Delivery Network (CDN) that caches web content (images, videos, static APIs) at Edge Locations.
- **Amazon Route 53:** Scalable Domain Name System (DNS) web service providing low-latency DNS resolution worldwide.
- **AWS Global Accelerator:** Uses AWS global network infrastructure to route user traffic through the nearest Edge Location over an optimized private network path, improving TCP/UDP performance by up to 60%.
- **AWS Shield:** Managed DDoS protection service deployed natively at edge locations.

---

## 4. Region Selection Decision Matrix

Choosing the right AWS Region is a critical architectural decision influenced by four primary factors:

```
                  +-----------------------------------+
                  |      REGION SELECTION CRITERIA    |
                  +-----------------+-----------------+
                                    |
     +-----------------+------------+------------+-----------------+
     |                 |                         |                 |
     v                 v                         v                 v
+----------+     +-----------+             +-----------+     +-----------+
| Compliance|    | Latency   |             | Services  |     | Cost      |
| & Governance|  | Reduction |             | Avail.    |     | Optim.    |
+----------+     +-----------+             +-----------+     +-----------+
```

| Factor | Architectural Consideration | Business Example |
|---|---|---|
| Compliance & Data Sovereignty | Legal rules requiring data to remain within specific national borders. | GDPR regulations requiring EU citizen data to be stored within European Regions (e.g., eu-central-1). |
| Latency & User Proximity | Deploying resources closest to the majority of end users to minimize network lag. | Placing web application instances in ap-northeast-1 (Tokyo) for East Asian user bases. |
| Service Availability | Not all AWS services or features are immediately available in every Region. | Newer AI services or custom EC2 instance families might debut first in flagship Regions (us-east-1 or eu-west-1). |
| Pricing Differences | Taxes, fiber infrastructure cost, and regional operational costs vary, causing service price differences across Regions. | An EC2 instance in us-east-1 can be up to 20% cheaper than the identical instance type in sa-east-1 (São Paulo). |

---

## 5. Resiliency & Architectural Patterns

High Availability (HA) and Fault Tolerance depend directly on how multi-location capabilities are applied in system designs.

### 5.1 Multi-AZ Architecture (High Availability)

Deploying workload resources across at least two independent AZs within a single Region.

- **Goal:** Protect against data center-level hardware failure or power grid outages.
- **AWS Implementation:** Place EC2 instances behind an Application Load Balancer (ALB) spanning Multiple AZs, with Amazon RDS configured in Multi-AZ mode for automated database failover.

### 5.2 Multi-Region Architecture (Disaster Recovery & Global Reach)

Deploying fully functional stacks across two or more separate AWS Regions.

- **Goal:** Protect against catastrophic regional disasters or fulfill extremely low RTO (Recovery Time Objective) and RPO (Recovery Point Objective) targets.
- **AWS Implementation:** Amazon DynamoDB Global Tables, Amazon S3 Cross-Region Replication (CRR), and Amazon Route 53 Latency-Based or Failover Routing policies.

---

## 6. Business Value & Recruiter Summary

**Business Impact:** Leveraging AWS Global Infrastructure reduces operational risks of hardware failures, provides elastic scalability on demand, and avoids the immense CapEx required to build global data centers.

**Key Terms for Technical Interviews:** Availability Zone, AWS Region, Edge Location, Points of Presence (PoP), CloudFront, Multi-AZ, Cross-Region Replication, Latency-Based Routing, Data Sovereignty.