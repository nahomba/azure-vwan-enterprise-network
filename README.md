# azure-vwan-enterprise-network

Terraform • DevOps • Multi-Region • Zero Trust
 Overview

This project demonstrates a production-grade Azure architecture built using Terraform (Infrastructure as Code) and deployed via secure CI/CD pipelines with approval gates.

It is designed based on real enterprise cloud principles:

Multi-region high availability
Zero Trust security (layered defense)
Controlled deployments (approval gates)
Cost-aware design (FinOps)
Fully modular Terraform architecture
Architecture Overview


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

 Environments:
DEV (Cost-Optimized)
Single region (East US)
Minimal resources
Firewall Basic
No Front Door

PROD (Enterprise-Grade):
Multi-region (East US + West Europe)
Azure Front Door Premium
Azure Firewall Premium
Full monitoring + diagnostics
Approval-gated deployments
Security & Governance
Security Layers
Azure Front Door (Global WAF)
Application Gateway WAF (Regional)
Azure Firewall (L3–L7 inspection)
NSGs (network segmentation)
Private workloads (no public IPs)

 DevSecOps
Checkov security scanning
Terraform validation & formatting
Secure authentication via OIDC
No secrets stored in GitHub

 Governance Controls
Manual approval gates for production
Environment protection rules
Controlled Terraform apply using saved plans

CI/CD Pipeline:
Validation → Security Scan → Plan → Approval → Apply

 Pipeline Features
Terraform validation (fmt, validate)
Security scanning (Checkov)
Plan artifact storage (tfplan)
Manual approval before production apply
OIDC-based Azure authentication

 Project Structure
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
│       ├── vwan/
│       ├── vhub/
│       ├── spoke/
│       ├── firewall/
│       ├── appgateway/
│       ├── frontdoor/
│       ├── monitoring/
│       ├── vm/
│       ├── vpn/
│       ├── vpn-connection/
│       ├── route-table/
│       ├── routing-intent/
│       ├── private-endpoint/
│       ├── private-dns/
│       └── nsg/

 Key Modules:

Module	           Purpose
vwan	          Global network backbone
vhub	          Regional hubs
spoke	          Application VNets
firewall	      Centralized security
appgateway	      Regional load balancing (WAF)
frontdoor	      Global entry point
vpn	              Hybrid connectivity
monitoring	      Logs and diagnostics
routing-intent	  Traffic control policies

 Observability
Log Analytics Workspace
Diagnostic settings for:
Firewalls
Application Gateways
Virtual Machines

 FinOps Approach
This project applies FinOps principles:
Environment-based cost control (DEV vs PROD)
Resource tagging for visibility
Cost-aware architecture decisions

 See:

docs/FinOps.md
docs/COST_ANALYSIS.md

Important Notes:
Backend workloads are private (no public exposure)
Azure Firewall is deployed in hub (not inline by default)
Traffic routing via firewall depends on routing configuration

 Next Steps

Planned improvements:
 End-to-end TLS with Azure Key Vault
 Advanced routing policies (failover + segmentation)
 Private Endpoints for deeper Zero Trust
 Cost optimization (logging + SKUs)
 Key Takeaway

This project reflects a shift from deploying infrastructure to designing secure, scalable, and governed cloud systems.

Related Documentation:
diagrams/architecture.md
docs/COST_ANALYSIS.md
docs/FinOps.md
