# Azure Virtual WAN Enterprise Network

**Terraform • DevOps • Multi-Region • Zero Trust**

---

## Overview

This project demonstrates a **production-grade Azure architecture** built using **Terraform (Infrastructure as Code)** and deployed through **secure CI/CD pipelines with approval gates**.

It is designed based on real-world enterprise cloud principles:

- Multi-region high availability  
- Zero Trust security (layered defense)  
- Controlled deployments (approval gates)  
- Cost-aware architecture (FinOps)  
- Fully modular Terraform design  

---

## Architecture Overview

### Traffic Flow

```
User
  ↓
Azure Front Door (Global WAF)
  ↓
Application Gateway (Regional WAF)
  ↓
Private Backend (VMs in Spoke VNets)
  ↓
Azure Virtual WAN (Global Backbone)
  ↓
Azure Firewall (Centralized Security)
```

---

## Environments

### DEV (Cost-Optimized)

- Single region (East US)  
- Minimal infrastructure footprint  
- Azure Firewall (Basic SKU)  
- No Azure Front Door  
- Reduced cost and simplified architecture  

---

### PROD (Enterprise-Grade)

- Multi-region (East US + West Europe)  
- Azure Front Door Premium (global entry point)  
- Azure Firewall Premium (advanced security)  
- Full monitoring and diagnostics  
- Approval-gated deployments  

---

## Security & Governance

### Layered Security (Zero Trust)

- Azure Front Door (Global WAF)  
- Application Gateway (Regional WAF)  
- Azure Firewall (L3–L7 inspection)  
- Network Security Groups (NSGs)  
- Private workloads (no public IP exposure)  

---

### DevSecOps

- Checkov security scanning  
- Terraform validation and formatting  
- Secure authentication via OIDC (no secrets in pipelines)  
- No credentials stored in GitHub  

---

### Governance Controls

- Manual approval gates for production  
- Environment protection rules  
- Controlled Terraform apply using saved plans  
- Drift prevention via CI/CD  

---

## CI/CD Pipeline

### Pipeline Flow

```
Validation → Security Scan → Plan → Approval → Apply
```

### Pipeline Features

- Terraform validation (`fmt`, `validate`)  
- Security scanning (Checkov)  
- Plan artifact storage (`tfplan`)  
- Manual approval before production deployment  
- OIDC-based Azure authentication  

---

## Project Structure

```
.
├── README.md
├── diagrams/
│   └── architecture.md
├── docs/
│   ├── COST_ANALYSIS.md
│   └── FinOps.md
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   └── prod/
│   └── modules/
```

---

## Key Modules

| Module            | Purpose                          |
|------------------|----------------------------------|
| vwan             | Global network backbone          |
| vhub             | Regional hubs                    |
| spoke            | Application VNets                |
| firewall         | Centralized security             |
| appgateway       | Regional load balancing (WAF)    |
| frontdoor        | Global entry point               |
| vpn              | Hybrid connectivity              |
| monitoring       | Logs and diagnostics             |
| routing-intent   | Traffic control policies         |
| private-endpoint | Private connectivity             |
| private-dns      | Internal name resolution         |

---

## Observability

- Azure Log Analytics Workspace  
- Diagnostic settings enabled for:
  - Azure Firewall  
  - Application Gateway  
  - Virtual Machines  

---

## FinOps Approach

This project applies **FinOps principles**:

- Environment-based cost control (DEV vs PROD)  
- Resource tagging for cost visibility  
- Cost-aware architecture decisions  

See:

- `docs/FinOps.md`  
- `docs/COST_ANALYSIS.md`  

---

## Important Notes

- Backend workloads are **fully private (no public exposure)**  
- Azure Firewall is deployed in the **hub (not inline by default)**  
- Traffic flows through the firewall **only when routing is configured**  

---

## Next Steps

- End-to-end TLS using Azure Key Vault  
- Advanced routing policies (failover and segmentation)  
- Private Endpoints for deeper Zero Trust  
- Cost optimization (logging, SKUs, scaling)  

---

## Key Takeaway

This project demonstrates a transition from **deploying infrastructure** to **designing secure, scalable, and governed cloud systems**, aligned with enterprise architecture best practices.

---

## Related Documentation

- `diagrams/architecture.md`  
- `docs/COST_ANALYSIS.md`  
- `docs/FinOps.md`  
