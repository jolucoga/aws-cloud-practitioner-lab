#!/usr/bin/env bash
#
# Lab 01 - Teardown
#
# Deletes every resource recorded in .lab01-state by deploy.sh, in reverse
# dependency order. Safe to run more than once: resources that are already gone
# are skipped.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="${SCRIPT_DIR}/.lab01-state"
PROJECT_TAG="CloudPractitioner-Lab01"

export AWS_PAGER=""

if [[ ! -f "${STATE_FILE}" ]]; then
  echo "No state file found (${STATE_FILE}). Nothing to delete."
  exit 0
fi

# Read known keys only (the state file is never sourced).
AWS_REGION="" VPC_ID="" IGW_ID="" SUBNET_ID="" ROUTE_TABLE_ID="" ROUTE_ASSOC_ID="" SG_ID="" INSTANCE_ID=""
while IFS='=' read -r key value; do
  case "${key}" in
    AWS_REGION|VPC_ID|IGW_ID|SUBNET_ID|ROUTE_TABLE_ID|ROUTE_ASSOC_ID|SG_ID|INSTANCE_ID)
      printf -v "${key}" '%s' "${value}" ;;
  esac
done < "${STATE_FILE}"

export AWS_DEFAULT_REGION="${AWS_REGION:-us-east-1}"
errors=0

# Run a command, report the outcome and keep going if it fails.
step() {
  local description="$1"; shift
  if output="$("$@" 2>&1)"; then
    echo " OK   ${description}"
    return 0
  fi
  echo " FAIL ${description}: ${output}" >&2
  errors=$((errors + 1))
  return 1
}

echo "======================================================"
echo " Lab 01 teardown (region: ${AWS_DEFAULT_REGION})"
echo "======================================================"

# 1. EC2 instance (must be gone before the security group and subnet can be deleted)
if [[ -n "${INSTANCE_ID}" ]]; then
  if step "Terminate instance ${INSTANCE_ID}" aws ec2 terminate-instances --instance-ids "${INSTANCE_ID}"; then
    echo "      waiting for termination..."
    aws ec2 wait instance-terminated --instance-ids "${INSTANCE_ID}" 2>/dev/null
  fi
fi

# 2. Security group (retry: network interface release can lag behind termination)
if [[ -n "${SG_ID}" ]]; then
  deleted=false
  for _ in $(seq 1 12); do
    if output="$(aws ec2 delete-security-group --group-id "${SG_ID}" 2>&1)"; then
      deleted=true; break
    fi
    [[ "${output}" == *InvalidGroup.NotFound* ]] && { deleted=true; break; }
    sleep 5
  done
  if [[ "${deleted}" == true ]]; then
    echo " OK   Delete security group ${SG_ID}"
  else
    echo " FAIL Delete security group ${SG_ID}: ${output}" >&2; errors=$((errors + 1))
  fi
fi

# 3. Route table association and route table
[[ -n "${ROUTE_ASSOC_ID}" ]]  && step "Disassociate route table (${ROUTE_ASSOC_ID})" aws ec2 disassociate-route-table --association-id "${ROUTE_ASSOC_ID}"
[[ -n "${ROUTE_TABLE_ID}" ]]  && step "Delete route table ${ROUTE_TABLE_ID}" aws ec2 delete-route-table --route-table-id "${ROUTE_TABLE_ID}"

# 4. Internet gateway (detach first)
if [[ -n "${IGW_ID}" ]]; then
  [[ -n "${VPC_ID}" ]] && step "Detach internet gateway ${IGW_ID}" aws ec2 detach-internet-gateway --internet-gateway-id "${IGW_ID}" --vpc-id "${VPC_ID}"
  step "Delete internet gateway ${IGW_ID}" aws ec2 delete-internet-gateway --internet-gateway-id "${IGW_ID}"
fi

# 5. Subnet, then VPC
[[ -n "${SUBNET_ID}" ]] && step "Delete subnet ${SUBNET_ID}" aws ec2 delete-subnet --subnet-id "${SUBNET_ID}"
[[ -n "${VPC_ID}" ]]    && step "Delete VPC ${VPC_ID}" aws ec2 delete-vpc --vpc-id "${VPC_ID}"

echo "------------------------------------------------------"
if [[ "${errors}" -eq 0 ]]; then
  rm -f "${STATE_FILE}"
  echo " Teardown completed. State file removed."
else
  echo " ${errors} step(s) failed. The state file was kept: fix the cause and run ./destroy.sh again." >&2
fi

# Final check: anything still tagged with this lab?
leftover="$(aws ec2 describe-vpcs --filters "Name=tag:Project,Values=${PROJECT_TAG}" \
  --query 'Vpcs[].VpcId' --output text 2>/dev/null)"
if [[ -n "${leftover}" ]]; then
  echo " Still present with tag Project=${PROJECT_TAG}: ${leftover}" >&2
fi
echo "======================================================"

[[ "${errors}" -eq 0 ]]
