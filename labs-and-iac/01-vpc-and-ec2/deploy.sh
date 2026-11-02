#!/usr/bin/env bash
#
# Lab 01 - Custom VPC + Amazon EC2 web server (AWS CLI)
#
# Creates: VPC, Internet Gateway, public subnet, route table, security group
# and one EC2 instance (Amazon Linux 2023) serving a web page through Apache.
#
# Every resource ID is written to .lab01-state as soon as it is created, so
# destroy.sh can remove everything, and this script rolls back by itself if
# any step fails.
#
# Optional environment variables:
#   AWS_REGION      Region to deploy to              (default: us-east-1)
#   INSTANCE_TYPE   EC2 instance type                (default: t3.micro)
#   ALLOW_SSH_CIDR  CIDR allowed on port 22          (default: empty = no SSH)
#   KEY_NAME        Existing EC2 key pair for SSH    (required with ALLOW_SSH_CIDR)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="${SCRIPT_DIR}/.lab01-state"

# ---------------------------------------------------------------- configuration
AWS_REGION="${AWS_REGION:-us-east-1}"
INSTANCE_TYPE="${INSTANCE_TYPE:-t3.micro}"
ALLOW_SSH_CIDR="${ALLOW_SSH_CIDR:-}"
KEY_NAME="${KEY_NAME:-}"

VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.1.0/24"
PROJECT_TAG="CloudPractitioner-Lab01"

export AWS_DEFAULT_REGION="${AWS_REGION}"
export AWS_PAGER=""

# ------------------------------------------------------------------- helpers
log()  { printf '%s\n' "$*"; }
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# Persist a variable (by name) to the state file the moment it is known.
save_state() { printf '%s=%s\n' "$1" "${!1}" >> "${STATE_FILE}"; }

# Tag specification used on every resource: Name + Project (for easy discovery).
tags() { printf 'ResourceType=%s,Tags=[{Key=Name,Value=%s-%s},{Key=Project,Value=%s}]' \
           "$1" "${PROJECT_TAG}" "$2" "${PROJECT_TAG}"; }

DEPLOY_DONE=false

# Runs on any exit. If the deployment did not finish (error, Ctrl-C), remove
# whatever was already created so nothing is left billing in the background.
on_exit() {
  local code=$?
  trap - EXIT
  if [[ "${DEPLOY_DONE}" != true && -s "${STATE_FILE}" ]]; then
    printf '\nERROR: deployment did not complete (exit code %s). Rolling back created resources...\n' "${code}" >&2
    "${SCRIPT_DIR}/destroy.sh" || printf 'Rollback incomplete: run ./destroy.sh again.\n' >&2
  fi
  exit "${code}"
}

# ----------------------------------------------------------------- pre-checks
command -v aws >/dev/null 2>&1 || fail "AWS CLI not found. Install AWS CLI v2 first."

[[ -f "${STATE_FILE}" ]] && fail "A previous deployment exists (${STATE_FILE}). Run ./destroy.sh first."

if [[ -n "${ALLOW_SSH_CIDR}" && -z "${KEY_NAME}" ]]; then
  fail "ALLOW_SSH_CIDR is set but KEY_NAME is empty. SSH needs an existing key pair."
fi

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)" \
  || fail "Could not authenticate. Run 'aws configure' or check your credentials."

log "======================================================"
log " Lab 01 - VPC + EC2 deployment"
log " Account: ${ACCOUNT_ID}   Region: ${AWS_REGION}"
log " Instance type: ${INSTANCE_TYPE}"
if [[ -n "${ALLOW_SSH_CIDR}" ]]; then
  log " SSH: allowed from ${ALLOW_SSH_CIDR} (key pair: ${KEY_NAME})"
else
  log " SSH: disabled (HTTP only)"
fi
log "======================================================"

: > "${STATE_FILE}"
save_state AWS_REGION
trap on_exit EXIT

# ------------------------------------------------------------ 1. VPC
log "[1/7] Creating VPC (${VPC_CIDR})..."
VPC_ID="$(aws ec2 create-vpc --cidr-block "${VPC_CIDR}" \
  --tag-specifications "$(tags vpc VPC)" \
  --query 'Vpc.VpcId' --output text)"
save_state VPC_ID
aws ec2 modify-vpc-attribute --vpc-id "${VPC_ID}" --enable-dns-hostnames '{"Value":true}'
log " -> ${VPC_ID}"

# ------------------------------------------------------------ 2. Internet Gateway
log "[2/7] Creating and attaching Internet Gateway..."
IGW_ID="$(aws ec2 create-internet-gateway \
  --tag-specifications "$(tags internet-gateway IGW)" \
  --query 'InternetGateway.InternetGatewayId' --output text)"
save_state IGW_ID
aws ec2 attach-internet-gateway --vpc-id "${VPC_ID}" --internet-gateway-id "${IGW_ID}"
log " -> ${IGW_ID}"

# ------------------------------------------------------------ 3. Public subnet
log "[3/7] Creating public subnet (${SUBNET_CIDR})..."
SUBNET_ID="$(aws ec2 create-subnet --vpc-id "${VPC_ID}" --cidr-block "${SUBNET_CIDR}" \
  --tag-specifications "$(tags subnet PublicSubnet)" \
  --query 'Subnet.SubnetId' --output text)"
save_state SUBNET_ID
aws ec2 modify-subnet-attribute --subnet-id "${SUBNET_ID}" --map-public-ip-on-launch
log " -> ${SUBNET_ID}"

# ------------------------------------------------------------ 4. Route table
log "[4/7] Creating route table with a default route to the Internet Gateway..."
ROUTE_TABLE_ID="$(aws ec2 create-route-table --vpc-id "${VPC_ID}" \
  --tag-specifications "$(tags route-table RouteTable)" \
  --query 'RouteTable.RouteTableId' --output text)"
save_state ROUTE_TABLE_ID
aws ec2 create-route --route-table-id "${ROUTE_TABLE_ID}" \
  --destination-cidr-block 0.0.0.0/0 --gateway-id "${IGW_ID}" > /dev/null
# shellcheck disable=SC2034  # read indirectly by save_state
ROUTE_ASSOC_ID="$(aws ec2 associate-route-table --route-table-id "${ROUTE_TABLE_ID}" \
  --subnet-id "${SUBNET_ID}" --query 'AssociationId' --output text)"
save_state ROUTE_ASSOC_ID
log " -> ${ROUTE_TABLE_ID}"

# ------------------------------------------------------------ 5. Security group
log "[5/7] Creating security group..."
SG_ID="$(aws ec2 create-security-group --group-name "${PROJECT_TAG}-SG" \
  --description "Lab 01 web server" --vpc-id "${VPC_ID}" \
  --tag-specifications "$(tags security-group SG)" \
  --query 'GroupId' --output text)"
save_state SG_ID

# HTTP is public on purpose: this is a web server.
aws ec2 authorize-security-group-ingress --group-id "${SG_ID}" \
  --protocol tcp --port 80 --cidr 0.0.0.0/0 > /dev/null
log " -> ${SG_ID} (inbound: HTTP 80 from anywhere)"

# SSH is opt-in and must be restricted to a specific CIDR (e.g. "203.0.113.7/32").
if [[ -n "${ALLOW_SSH_CIDR}" ]]; then
  aws ec2 authorize-security-group-ingress --group-id "${SG_ID}" \
    --protocol tcp --port 22 --cidr "${ALLOW_SSH_CIDR}" > /dev/null
  log "    (inbound: SSH 22 from ${ALLOW_SSH_CIDR})"
fi

# ------------------------------------------------------------ 6. AMI lookup
log "[6/7] Looking up the latest Amazon Linux 2023 AMI..."
AMI_ID="$(aws ssm get-parameter \
  --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
  --query 'Parameter.Value' --output text)"
log " -> ${AMI_ID}"

# ------------------------------------------------------------ 7. EC2 instance
log "[7/7] Launching EC2 instance..."
USER_DATA="$(cat <<'EOF'
#!/bin/bash
set -e
dnf install -y httpd
systemctl enable --now httpd

# Read instance details from the metadata service using IMDSv2 (token-based).
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 60")
META() { curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" "http://169.254.169.254/latest/meta-data/$1"; }

cat > /var/www/html/index.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"><title>AWS Cloud Practitioner - Lab 01</title></head>
<body>
  <h1>AWS Cloud Practitioner - Lab 01 successful</h1>
  <p>Served by Apache on Amazon EC2, inside a custom VPC.</p>
  <ul>
    <li>Instance ID: $(META instance-id)</li>
    <li>Availability Zone: $(META placement/availability-zone)</li>
    <li>Instance type: $(META instance-type)</li>
  </ul>
</body>
</html>
HTML
EOF
)"

SSH_ARGS=()
if [[ -n "${KEY_NAME}" ]]; then
  SSH_ARGS=(--key-name "${KEY_NAME}")
fi

INSTANCE_ID="$(aws ec2 run-instances \
  --image-id "${AMI_ID}" \
  --instance-type "${INSTANCE_TYPE}" \
  --count 1 \
  --subnet-id "${SUBNET_ID}" \
  --security-group-ids "${SG_ID}" \
  --user-data "${USER_DATA}" \
  --metadata-options 'HttpTokens=required,HttpEndpoint=enabled' \
  --block-device-mappings 'DeviceName=/dev/xvda,Ebs={VolumeSize=8,VolumeType=gp3,Encrypted=true,DeleteOnTermination=true}' \
  --tag-specifications "$(tags instance WebServer)" "$(tags volume RootVolume)" \
  ${SSH_ARGS[@]+"${SSH_ARGS[@]}"} \
  --query 'Instances[0].InstanceId' --output text)"
save_state INSTANCE_ID
log " -> ${INSTANCE_ID}"

log "Waiting for the instance to pass its status checks..."
aws ec2 wait instance-running --instance-ids "${INSTANCE_ID}"
aws ec2 wait instance-status-ok --instance-ids "${INSTANCE_ID}"

PUBLIC_IP="$(aws ec2 describe-instances --instance-ids "${INSTANCE_ID}" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)"

# Status checks pass before user-data finishes, so poll the web server itself.
if command -v curl >/dev/null 2>&1; then
  log "Waiting for Apache to answer on http://${PUBLIC_IP} ..."
  for attempt in $(seq 1 30); do
    if curl -fsS --max-time 5 "http://${PUBLIC_IP}" > /dev/null 2>&1; then
      log " -> Web server is responding."
      break
    fi
    [[ "${attempt}" -eq 30 ]] && log " -> No response yet; it may need another minute. Try the URL manually."
    sleep 10
  done
fi

DEPLOY_DONE=true

log "======================================================"
log " Deployment completed"
log "------------------------------------------------------"
log " VPC ID:       ${VPC_ID}"
log " Subnet ID:    ${SUBNET_ID}"
log " Instance ID:  ${INSTANCE_ID}"
log " Public IP:    ${PUBLIC_IP}"
log " URL:          http://${PUBLIC_IP}"
log "------------------------------------------------------"
log " Resources keep accruing charges. When finished, run:"
log "   ./destroy.sh"
log "======================================================"
