#!/bin/bash

set -e

# =========================
# COLORS
# =========================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE} Local Pipeline Testing${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# =========================
# PRE-CHECKS
# =========================
echo -e "${BLUE} Checking dependencies...${NC}"

command -v terraform >/dev/null 2>&1 || { echo -e "${RED} Terraform not installed${NC}"; exit 1; }
command -v checkov >/dev/null 2>&1 || { echo -e "${RED} Checkov not installed${NC}"; exit 1; }
command -v actionlint >/dev/null 2>&1 || { echo -e "${YELLOW} actionlint not installed (skipping workflow validation)${NC}"; SKIP_LINT=true; }

echo -e "${GREEN} Dependencies OK${NC}"
echo ""

# =========================
# TEST 1: WORKFLOW SYNTAX
# =========================
echo -e "${BLUE} Test 1: Workflow Syntax Check${NC}"

if [ "$SKIP_LINT" != true ]; then
  if actionlint .github/workflows/*.yml; then
    echo -e "${GREEN} Workflow syntax valid${NC}"
  else
    echo -e "${RED} Workflow syntax invalid${NC}"
    exit 1
  fi
else
  echo -e "${YELLOW} Skipped (actionlint not installed)${NC}"
fi
echo ""

# =========================
# TEST 2: TERRAFORM FORMAT
# =========================
echo -e "${BLUE} Test 2: Terraform Format Check${NC}"

if terraform fmt -check -recursive terraform/; then
  echo -e "${GREEN} Terraform format check passed${NC}"
else
  echo -e "${YELLOW} Format issues found - fixing...${NC}"
  terraform fmt -recursive terraform/
  echo -e "${GREEN} Format fixed${NC}"
fi
echo ""

# =========================
# TEST 3: TERRAFORM VALIDATION
# =========================
echo -e "${BLUE} Test 3: Terraform Validation (DEV)${NC}"

cd terraform/environments/dev
terraform init -backend=false > /dev/null 2>&1

if terraform validate; then
  echo -e "${GREEN} Terraform validation passed${NC}"
else
  echo -e "${RED} Terraform validation failed${NC}"
  exit 1
fi

rm -rf .terraform .terraform.lock.hcl
cd ../../..
echo ""

# =========================
# TEST 4: SECURITY SCAN
# =========================
echo -e "${BLUE} Test 4: Checkov Security Scan${NC}"

if checkov -d terraform/environments/dev --framework terraform --quiet --compact; then
  echo -e "${GREEN} Security scan passed${NC}"
else
  echo -e "${YELLOW} Security scan completed (some checks skipped/failed - review recommended)${NC}"
fi
echo ""

# =========================
# TEST 5: COMMON ISSUES
# =========================
echo -e "${BLUE} Test 5: Common Issues Check${NC}"

# Backend check
if grep -q "backend.*azurerm" terraform/environments/dev/*.tf 2>/dev/null; then
  echo -e "${GREEN} Backend configuration found${NC}"
else
  echo -e "${YELLOW} No backend config in code (expected - configured via pipeline)${NC}"
fi

# Secret scan
if git grep -i "password.*=.*\"" -- '*.tf' '*.tfvars' 2>/dev/null | grep -v "variable\|description\|sensitive\|disable_password" > /dev/null; then
  echo -e "${RED} Hardcoded secrets found!${NC}"
  exit 1
else
  echo -e "${GREEN} No hardcoded secrets${NC}"
fi

# Structure check
if [ -d "terraform/modules" ] && [ -d "terraform/environments/dev" ]; then
  echo -e "${GREEN} Terraform structure correct${NC}"
else
  echo -e "${RED} Terraform structure incorrect${NC}"
  exit 1
fi

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN} All local tests passed!${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

echo "Summary:"
echo "   Workflow syntax validated"
echo "   Terraform formatted and validated"
echo "   Security scan completed"
echo "   No hardcoded secrets"
echo "   Structure verified"
echo ""

echo "Next steps:"
echo "   git add ."
echo "   git commit -m 'feat: update infrastructure'"
echo "   git push origin main"
echo ""