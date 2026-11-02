# Lab 01: Custom VPC & Amazon EC2 Web Server (AWS CLI)

Build a small but complete AWS network from scratch with the AWS CLI, launch a web server inside it, verify it, and tear everything down again with a single command.

| | |
|---|---|
| **Exam domain** | Domain 3: Cloud Technology and Services (with Domain 2 security practices) |
| **Services** | Amazon VPC, Internet Gateway, Route Tables, Security Groups, Amazon EC2, EBS, Systems Manager Parameter Store |
| **Tooling** | Bash + AWS CLI v2 |
| **Duration** | About 10 minutes to deploy, 2 minutes to destroy |
| **Cost** | A few cents if destroyed the same day (see [Cost](#cost)) |

---

## 1. Architecture

```text
                              Internet
                                 |
                       +---------+----------+
                       |  Internet Gateway  |
                       +---------+----------+
                                 |
+--------------------------------+--------------------------------+
| VPC 10.0.0.0/16                |                                 |
|                                |                                 |
|   Route table: 0.0.0.0/0 --> Internet Gateway                    |
|                                |                                 |
|   +----------------------------+----------------------------+    |
|   | Public subnet 10.0.1.0/24                               |    |
|   |                                                         |    |
|   |   +-------------------------------------------------+   |    |
|   |   | Security group: inbound TCP 80 (HTTP)           |   |    |
|   |   |                                                 |   |    |
|   |   |   EC2 instance (Amazon Linux 2023 + Apache)     |   |    |
|   |   |   encrypted gp3 root volume, IMDSv2 required    |   |    |
|   |   +-------------------------------------------------+   |    |
|   +---------------------------------------------------------+    |
+------------------------------------------------------------------+
```

**Traffic flow.** A browser sends an HTTP request to the instance's public IPv4 address. The Internet Gateway forwards it into the VPC, the route table directs it to the subnet, the security group allows port 80, and Apache answers. The reply follows the same path back because security groups are *stateful*.

## 2. Resources created

| Resource | Configuration | Purpose |
|---|---|---|
| **VPC** | `10.0.0.0/16`, DNS hostnames enabled | Isolated virtual network that you control |
| **Internet Gateway** | Attached to the VPC | Connects the VPC to the public internet |
| **Public subnet** | `10.0.1.0/24`, auto-assign public IPv4 | A subnet is *public* because its route table points to an Internet Gateway |
| **Route table** | Default route `0.0.0.0/0` to the IGW, associated with the subnet | Decides where outbound and inbound traffic goes |
| **Security group** | Inbound TCP 80 from anywhere; no other inbound rules | Stateful, instance-level firewall |
| **EC2 instance** | Amazon Linux 2023, `t3.micro` by default | The web server |
| **EBS root volume** | 8 GiB gp3, encrypted | Block storage for the operating system |

Every resource is tagged with `Name` and `Project=CloudPractitioner-Lab01`, which makes the lab easy to find in the console and in cost reports.

## 3. Security decisions

| Decision | Reason | Trade-off |
|---|---|---|
| **No SSH by default** | The page is served by user-data; nobody needs a shell. Fewer open ports means a smaller attack surface | You cannot log in. Opt in with `ALLOW_SSH_CIDR` and `KEY_NAME`, restricted to your own IP |
| **HTTP open to `0.0.0.0/0`** | It is a public web server | Traffic is unencrypted. A production site would use HTTPS behind a load balancer |
| **IMDSv2 required** | Token-based metadata access mitigates credential theft through SSRF | Very old software that only speaks IMDSv1 would break |
| **Encrypted EBS volume** | Data at rest is encrypted with the AWS managed key | Negligible performance impact |
| **Public subnet with a public IP** | Keeps the lab free of NAT Gateway charges | A real workload would sit in a private subnet behind a load balancer |
| **Rollback on failure** | A failed run never leaves billable resources behind | None |

**Shared responsibility in practice.** AWS secures the physical infrastructure, the hypervisor and the VPC service itself. In this lab *you* are responsible for the security group rules, the instance configuration, the operating system patching and the data on the instance.

## 4. Prerequisites

- **AWS account** and credentials configured with `aws configure` (or SSO). The AWS CLI **v2** is required.
- **Bash**: Linux, macOS, or WSL / Git Bash on Windows. The repository's `.gitattributes` forces LF line endings so the scripts do not break on Windows checkouts.
- **Permissions.** An administrator account works, but least privilege is better. This policy is a starting point (verify it in your account before relying on it):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateVpc", "ec2:ModifyVpcAttribute", "ec2:DeleteVpc", "ec2:DescribeVpcs",
        "ec2:CreateInternetGateway", "ec2:AttachInternetGateway",
        "ec2:DetachInternetGateway", "ec2:DeleteInternetGateway",
        "ec2:CreateSubnet", "ec2:ModifySubnetAttribute", "ec2:DeleteSubnet",
        "ec2:CreateRouteTable", "ec2:CreateRoute", "ec2:AssociateRouteTable",
        "ec2:DisassociateRouteTable", "ec2:DeleteRouteTable",
        "ec2:CreateSecurityGroup", "ec2:AuthorizeSecurityGroupIngress", "ec2:DeleteSecurityGroup",
        "ec2:RunInstances", "ec2:TerminateInstances",
        "ec2:DescribeInstances", "ec2:DescribeInstanceStatus",
        "ec2:CreateTags",
        "ssm:GetParameter"
      ],
      "Resource": "*"
    }
  ]
}
```

## 5. Usage

```bash
cd labs-and-iac/01-vpc-and-ec2/
./deploy.sh
```

If the scripts are not executable (for example after downloading a ZIP), run `chmod +x deploy.sh destroy.sh` first.

Optional settings are passed as environment variables:

| Variable | Default | Description |
|---|---|---|
| `AWS_REGION` | `us-east-1` | Region to deploy to |
| `INSTANCE_TYPE` | `t3.micro` | EC2 instance type. Check Free Tier eligibility for your account and region |
| `ALLOW_SSH_CIDR` | *(empty)* | CIDR allowed on port 22, for example `203.0.113.7/32`. Empty means no SSH |
| `KEY_NAME` | *(empty)* | Existing EC2 key pair. Required when `ALLOW_SSH_CIDR` is set |

```bash
# Example: another region, with SSH restricted to one address
AWS_REGION=us-west-2 ALLOW_SSH_CIDR=203.0.113.7/32 KEY_NAME=my-key ./deploy.sh
```

### What the script does

1. Creates the VPC and enables DNS hostnames.
2. Creates and attaches the Internet Gateway.
3. Creates the public subnet with automatic public IPv4 assignment.
4. Creates the route table, adds the default route and associates it with the subnet.
5. Creates the security group and opens port 80 (and 22 only if requested).
6. Looks up the latest Amazon Linux 2023 AMI through the public SSM parameter, so no AMI ID is hard-coded.
7. Launches the instance with a user-data script that installs Apache and publishes a page showing the instance ID and Availability Zone, read through IMDSv2.

Each resource ID is saved to `.lab01-state` the moment it exists. If any step fails, or you press Ctrl+C, `deploy.sh` calls `destroy.sh` automatically.

### Expected output

```text
======================================================
 Lab 01 - VPC + EC2 deployment
 Account: 123456789012   Region: us-east-1
 Instance type: t3.micro
 SSH: disabled (HTTP only)
======================================================
[1/7] Creating VPC (10.0.0.0/16)...
 -> vpc-0123456789abcdef0
...
[7/7] Launching EC2 instance...
 -> i-0123456789abcdef0
Waiting for the instance to pass its status checks...
Waiting for Apache to answer on http://203.0.113.10 ...
 -> Web server is responding.
======================================================
 Deployment completed
 URL:          http://203.0.113.10
======================================================
```

*(IDs and addresses are illustrative.)*

## 6. Verification

**Web server.** Open the URL printed by the script. The page shows the instance ID, the Availability Zone and the instance type.

```bash
curl -i http://<PUBLIC_IP>
```

**From the CLI.** Confirm the pieces are wired together as designed:

```bash
# The route table sends internet traffic to the Internet Gateway
aws ec2 describe-route-tables \
  --filters "Name=tag:Project,Values=CloudPractitioner-Lab01" \
  --query 'RouteTables[].Routes[].[DestinationCidrBlock,GatewayId]' --output table

# Only port 80 is open
aws ec2 describe-security-groups \
  --filters "Name=tag:Project,Values=CloudPractitioner-Lab01" \
  --query 'SecurityGroups[].IpPermissions[].[FromPort,ToPort,IpRanges[0].CidrIp]' --output table

# IMDSv2 is enforced
aws ec2 describe-instances \
  --filters "Name=tag:Project,Values=CloudPractitioner-Lab01" \
  --query 'Reservations[].Instances[].MetadataOptions.HttpTokens' --output text
```

**Negative test.** Try `curl --max-time 5 http://<PUBLIC_IP>:22`. The connection should time out, because the security group drops anything that is not on port 80.

## 7. Cleanup

```bash
./destroy.sh
```

The script terminates the instance and then deletes, in reverse dependency order: security group, route table association and route table, Internet Gateway (detach first), subnet and VPC. It is safe to run twice, keeps the state file if something fails so you can retry, and finally checks that nothing tagged `Project=CloudPractitioner-Lab01` is left.

> **Always run it when you finish.** The instance, the public IPv4 address and the EBS volume are billed while they exist.

## 8. Cost

| Item | Notes |
|---|---|
| EC2 instance | Billed per second while running. May be covered by the Free Tier depending on the account type and region |
| Public IPv4 address | AWS charges for every public IPv4 address, including while attached to a running instance (about $0.005 per hour at the time of writing) |
| EBS volume | 8 GiB gp3, billed while the volume exists |
| VPC, subnet, route table, Internet Gateway, security group | No charge |
| Data transfer | Inbound is free; outbound to the internet is billed after the free allowance |

There is deliberately **no NAT Gateway**, the most common source of surprise charges in beginner labs. Check current prices with the [AWS Pricing Calculator](https://calculator.aws/) before running the lab in a new region.

## 9. Troubleshooting

| Symptom | Likely cause and fix |
|---|---|
| `A previous deployment exists` | A `.lab01-state` file is present. Run `./destroy.sh`, then deploy again |
| `Could not authenticate` | Credentials are missing or expired. Run `aws configure` or `aws sso login` |
| `UnauthorizedOperation` | The IAM identity lacks one of the actions listed in [Prerequisites](#4-prerequisites) |
| `Unsupported` or `InvalidParameterValue` for the instance type | The type is not available in that Region or Availability Zone. Set `INSTANCE_TYPE` to another type |
| `VpcLimitExceeded` | The Region already has 5 VPCs (the default quota). Delete an unused one or use another Region |
| Page does not load right away | User-data finishes after the status checks. Wait a minute and retry |
| Page never loads | Check the security group (port 80), that the subnet route table has the default route, and that the instance has a public IP |
| `DependencyViolation` on teardown | A network interface is still releasing. The script retries; if it persists, run `./destroy.sh` again after a minute |
| `bash\r: No such file or directory` | Windows line endings. Run `git config core.autocrlf false`, re-clone, or `dos2unix *.sh` |

## 10. Evidence

<!--
Add screenshots of your own run to an `images/` folder next to this file and uncomment:

![VPC resource map](images/vpc-resource-map.png)
![Web page served by the instance](images/web-page.png)
![Resources after destroy.sh](images/after-destroy.png)
-->

## 11. What this lab demonstrates

| CLF-C02 concept | Where it appears |
|---|---|
| Regions and Availability Zones | The instance reports its AZ; the subnet lives in one AZ |
| Public vs. private subnet | A subnet is public because its route table points to an Internet Gateway |
| Security groups (stateful) vs. network ACLs (stateless) | The security group allows only port 80; return traffic needs no rule |
| Shared responsibility model | AWS runs the VPC service; the customer configures rules, OS and data |
| Principle of least privilege | No SSH by default, restricted SSH when enabled, a scoped IAM policy |
| Encryption at rest | Encrypted EBS root volume |
| Infrastructure as Code | Repeatable, versioned deployment and teardown, in place of console clicks |
| Cost awareness | Public IPv4 charges, no NAT Gateway, same-day teardown |

## 12. Possible extensions

- Add an **Application Load Balancer** and move the instance to a **private subnet** (needs a second subnet in another AZ and a NAT Gateway or VPC endpoints).
- Replace SSH with **AWS Systems Manager Session Manager** using an instance profile.
- Rewrite the lab with **AWS CloudFormation** or **Terraform** and compare it with the CLI approach.
- Put the instance in an **Auto Scaling group** across two Availability Zones.
