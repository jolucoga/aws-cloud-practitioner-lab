# AWS Support Plans, Advisory Services & Health Monitoring

## 1. Executive Summary

Navigating production workloads in the cloud requires access to expert guidance, proactive infrastructure reviews, and technical assistance during operational incidents. AWS provides four distinct tiers of support plans designed to scale with organizational needs, alongside automated advisory engines like **AWS Trusted Advisor** and the **AWS Health Dashboard**.

---

## 2. AWS Support Plans Comparison

AWS offers four support plans: **Basic**, **Developer**, **Business**, and **Enterprise**.

```
┌─────────────────────────────────────────────────────────────────────────┐
|                       AWS SUPPORT PLAN HIERARCHY                        |
├─────────────────────────────────────────────────────────────────────────┤
| ENTERPRISE | 24/7 access, TAM assigned, < 15-min critical response time  |
| BUSINESS   | 24/7 phone/chat/email access, production system down < 1-hr|
| DEVELOPER  | Business hours email support, general guidance < 24-hrs     |
| BASIC      | 24/7 customer service, documentation, whitepapers (Free)  |
└─────────────────────────────────────────────────────────────────────────┘
```

| Feature / Metric | Basic Support | Developer Support | Business Support | Enterprise Support |
|---|---|---|---|---|
| Target Audience | All AWS accounts (default) | Non-production / Testing environments | Production workloads | Mission-critical enterprise workloads |
| Pricing | Included for Free | Greater of $29/mo or % of monthly AWS spend | Greater of $100/mo or % of monthly AWS spend | Greater of $15,000/mo or % of monthly spend |
| Technical Support | Customer Service & Billing only | Email access during local business hours | 24/7 Phone, Chat, and Email access | 24/7 Phone, Chat, and Email access |
| Response Time (Critical) | N/A | N/A | < 1 hour (Production system down) | < 15 minutes (Business-critical system down) |
| Technical Account Manager (TAM) | No | No | No | Designated TAM assigned to the organization |
| AWS Trusted Advisor | Core checks only | Core checks only | Full set of checks | Full set of checks |

---

## 3. Automated Advisory Tools

### 3.1 AWS Trusted Advisor

AWS Trusted Advisor is an automated online tool that inspects your AWS environment in real time and provides recommendations across five core categories to help align with AWS best practices.

```
┌─────────────────────────────────────────────────────────────────────────┐
|                  TRUSTED ADVISOR FIVE PILLARS                           |
+---------------------+-----------------------+---------------------------+
| Category            | Focus Area            | Example Recommendation    |
+---------------------+-----------------------+---------------------------+
| Cost Optimization   | Financial Efficiency  | Unattached EBS volumes,   |
|                     |                       | Idle load balancers       |
| Performance         | Resource Throughput   | High EC2 utilization,     |
|                     |                       | CloudFront optimization   |
| Security            | Defensive Controls    | Public S3 buckets,        |
|                     |                       | Root account MFA disabled |
| Fault Tolerance     | Resiliency & High Avail| Missing DB backups,       |
|                     |                       | Single-AZ deployments     |
| Service Limits      | Capacity Governance   | Approaching quota limits  |
| (Service Quotas)    |                       | for VPCs or Elastic IPs   |
+---------------------+-----------------------+---------------------------+
```

---

## 4. Operational Health Monitoring

AWS provides two health dashboards to distinguish between general system-wide service availability and incidents impacting your specific resources.

```
┌─────────────────────────────────────────────────────────────────────────┐
|                  HEALTH DASHBOARDS DISTINCTION                          |
├───────────────────────────────────┬─────────────────────────────────────┤
| AWS Health Official Dashboard     | AWS Health Dashboard                |
| (Public / Global)                 | (Account / Personal)                |
├───────────────────────────────────┼─────────────────────────────────────┤
| Shows global service availability | Personalized view of specific events|
| across all AWS Regions.           | impacting YOUR underlying resources.|
| Publicly viewable by anyone.      | Requires logging into AWS Console.  |
| Example: "S3 degraded in us-east-1"| Example: "EC2 instance i-1234      |
|                                   | scheduled for hardware maintenance."|
└───────────────────────────────────┴─────────────────────────────────────┘
```

---

## 5. Recruiter & Technical Interview Takeaways

**Business Impact:** Selecting the appropriate support tier ensures minimal SLA impact during production outages, while Trusted Advisor checks continuously optimize cost and security posture automatically.

**Key Terms for Technical Interviews:** Technical Account Manager (TAM), 15-minute Critical SLA (Enterprise), AWS Trusted Advisor (5 Pillars), AWS Health Dashboard vs AWS Health Official Dashboard, Business vs Enterprise Support Response Times.