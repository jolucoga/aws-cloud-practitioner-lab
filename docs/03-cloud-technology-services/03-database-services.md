# AWS Database & Analytics Services Architecture

## 1. Executive Summary

AWS offers purpose-built database engines tailored to specific application requirements—eliminating the trade-offs of using a single relational database for every workload. These services range from fully managed Relational Database Services (RDS/Aurora) to Serverless NoSQL (DynamoDB), In-Memory Caching (ElastiCache), and Data Warehousing (Redshift).

Selecting the proper database strategy directly impacts system throughput, latency, global availability, and operational overhead.

---

## 2. AWS Managed Database Portfolio Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
|                    AWS PURPOSE-BUILT DATABASES                          |
├──────────────────┬──────────────────────┬───────────────────────────────┤
| Model            | Key Service          | Primary Use Case              |
├──────────────────┼──────────────────────┼───────────────────────────────┤
| Relational (SQL) | Amazon RDS / Aurora  | ERP, CRM, E-commerce transactions|
| Key-Value NoSQL  | Amazon DynamoDB      | High-scale microservices, gaming|
| In-Memory Cache  | Amazon ElastiCache   | Session caching, real-time analytics|
| Data Warehouse   | Amazon Redshift      | Enterprise BI, OLAP queries    |
└──────────────────┴──────────────────────┴───────────────────────────────┘
```

---

## 3. Relational vs. Non-Relational (NoSQL) Databases

```
┌─────────────────────────────────────────────────────────────────────────┐
|                     RELATIONAL (RDS) VS. NOSQL (DYNAMODB)               |
├───────────────────────────────────┬─────────────────────────────────────┤
| Amazon RDS / Aurora               | Amazon DynamoDB                     |
├───────────────────────────────────┼─────────────────────────────────────┤
| Structured Data (Tables, Rows)    | Semi-structured (JSON, Key-Value)   |
| ACID Compliance & Complex Joins   | High throughput, single-digit ms    |
| Vertical & Read Replica Scaling   | Horizontal autoscaling (Serverless) |
| Managed OS & Database Engine      | Zero server administration          |
└───────────────────────────────────┴─────────────────────────────────────┘
```

### 3.1 Amazon RDS & Amazon Aurora

**Amazon RDS:** Managed relational database supporting six common engines: PostgreSQL, MySQL, MariaDB, Oracle, SQL Server, and Amazon Aurora. Handles automatic patching, backups, and point-in-time recovery.

**Amazon Aurora:** Enterprise-grade relational engine built for the cloud (compatible with MySQL and PostgreSQL). Provides up to 5x performance of standard MySQL and 3x of PostgreSQL, with storage that automatically scales up to 128 TiB and replicates 6 copies of data across 3 Availability Zones.

### 3.2 Amazon DynamoDB

Fully managed, serverless Key-Value and Document NoSQL database designed for single-digit millisecond performance at any scale.

**Global Tables:** Provides fully managed multi-region, multi-active database capabilities for global applications.

---

## 4. Specialized Database & Analytics Services

**Amazon ElastiCache:** In-memory caching service (supporting Redis OSS and Memcached) that accelerates application performance by caching frequently accessed read queries, reducing load on relational databases.

**Amazon Redshift:** Fast, fully managed, petabyte-scale Data Warehouse service using SQL and columnar storage for Online Analytical Processing (OLAP) and enterprise business intelligence.

**AWS Database Migration Service (DMS):** Migrates databases to AWS quickly and securely while keeping the source database operational during migration. Supports homogeneous (MySQL to MySQL) and heterogeneous (Oracle to PostgreSQL via Schema Conversion Tool) migrations.

---

## 5. Recruiter & Technical Interview Takeaways

**Business Impact:** Leveraging purpose-built databases avoids expensive database licensing costs, reduces manual DBA maintenance, and provides automatic high-availability across Availability Zones.

**Key Terms for Technical Interviews:** OLTP vs OLAP, Amazon Aurora Auto-scaling Storage, DynamoDB Global Tables, ElastiCache Redis/Memcached, Redshift Columnar Storage, AWS DMS.

---