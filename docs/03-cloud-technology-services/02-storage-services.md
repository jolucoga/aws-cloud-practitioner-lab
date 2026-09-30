# AWS Storage Services Architecture & Selection Guide

## 1. Executive Summary

AWS offers a comprehensive suite of cloud storage services tailored to different access patterns, performance requirements, and persistence models. Storage in AWS falls into three primary types: **Object Storage** (Amazon S3), **Block Storage** (Amazon EBS), and **File Storage** (Amazon EFS), alongside archival and hybrid migration solutions.

Selecting the correct storage service is vital for optimizing cost performance and establishing durable data backup policies.

---

## 2. Core AWS Storage Types Comparison

```
+-------------------------------------------------------------------------+
|                        AWS STORAGE TYPES OVERVIEW                       |
+-------------------+------------------------+----------------------------+
| Storage Type      | Service Example        | Ideal Use Case             |
+-------------------+------------------------+----------------------------+
| Object Storage    | Amazon S3              | Unstructured data, media,  |
|                   |                        | static site hosting, backups|
| Block Storage     | Amazon EBS             | Virtual disks attached to  |
|                   |                        | EC2 (OS, Databases)        |
| File Storage      | Amazon EFS             | Shared network file system |
|                   |                        | accessed by multiple EC2s  |
+-------------------+------------------------+----------------------------+
```

| Service | Storage Paradigm | Network Access / Mount | Key Characteristics |
|---|---|---|---|
| Amazon S3 | Object | HTTP/HTTPS REST API | Scalable, high durability (11 9's), accessible globally via Web URL. |
| Amazon EBS | Block | Attached directly to an EC2 instance in the same AZ | Low latency, persistence for virtual machine operating systems and databases. |
| Amazon EFS | Network File System (NFS) | Mounted concurrently by hundreds of EC2s across AZs | Fully managed POSIX file system with automatic capacity autoscaling. |
| AWS Storage Gateway | Hybrid Cloud | On-premises appliance to cloud storage | Seamlessly integrates local corporate networks with AWS S3 / EBS storage. |

---

## 3. Amazon Simple Storage Service (S3) Deep Dive

Amazon S3 is an object storage service offering industry-leading scalability, data availability, security, and performance.

### 3.1 S3 Storage Classes & Cost Hierarchy

Data access frequency dictates the optimal S3 Storage Class:

```
Frequent Access                                                Archive / Cold Data
  [S3 Standard] ──► [S3 Standard-IA] ──► [S3 One Zone-IA] ──► [S3 Glacier Instant] ──► [S3 Glacier Deep Archive]
    (Highest $)       (Infrequent)        (Single AZ)          (Retrieval: ms)          (Retrieval: 12 hrs / Lowest $)
```

| Storage Class | Designed For | Minimum Storage Duration | Retrieval Time |
|---|---|---|---|
| S3 Standard | Active, frequently accessed data (images, web assets). | None | Instant (milliseconds) |
| S3 Intelligent-Tiering | Workloads with unknown or changing access patterns (auto-tiering via ML). | 30 days | Instant (milliseconds) |
| S3 Standard-IA | Long-term data accessed infrequently (backups, disaster recovery). | 30 days | Instant (milliseconds) |
| S3 One Zone-IA | Recreatable, non-critical infrequent data saved in a single AZ. | 30 days | Instant (milliseconds) |
| S3 Glacier Flexible | Long-term archival data requiring occasional access. | 90 days | Minutes to 12 hours |
| S3 Glacier Deep Archive | Lowest cost storage for compliance/regulatory retention (tape replacement). | 180 days | Within 12 hours |

---

## 4. Block (EBS) vs. File (EFS) Storage Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
|                  BLOCK (EBS) VS. FILE (EFS) ARCHITECTURE                |
├───────────────────────────────────┬─────────────────────────────────────┤
| Amazon EBS (Elastic Block Store)  | Amazon EFS (Elastic File System)    |
├───────────────────────────────────┼─────────────────────────────────────┤
| Single EC2 Instance Attachment*   | Shared across Multi-EC2 / Multi-AZ  |
| Tied to a single Availability Zone| Regional availability (Multi-AZ)    |
| Block-level updates (databases)   | POSIX compliance file system        |
| Manual volume scaling required    | Scales capacity automatically       |
└─────────────────────────────────────────────────────────────────────────┘
```

**Note:** EBS Multi-Attach exists for specific Provisioned IOPS volumes, but single instance attachment is the standard pattern.

---

## 5. Data Durability, Availability & Migration

**Durability (11 9's):** Amazon S3 is designed for 99.999999999% durability by automatically redundantly storing objects across multiple physical facilities within an AWS Region.

**AWS Snowball / Snowcone / Snowmobile:** Physical hardware appliances used to transfer terabytes or petabytes of data into AWS without consuming corporate internet bandwidth.

---

## 6. Recruiter & Technical Interview Takeaways

**Business Impact:** Automated Lifecycle Policies (transitioning S3 objects to Glacier) drastically reduce corporate cloud storage spend over time.

**Key Terms for Technical Interviews:** Object Storage vs Block vs File, 11 9's Durability, S3 Storage Classes, Lifecycle Rules, EBS Snapshots, EFS Multi-AZ Mounting, AWS Snow Family.

---