# Azure Virtual WAN Enterprise Architecture (Terraform-Aligned)

## Overview

This project implements a **production-grade, multi-region Azure architecture** using Terraform, designed with a strong focus on:

- High availability  
- Zero Trust security  
- Global scalability  
- Network segmentation  
- Observability  
- Cost-awareness (FinOps)  

This is not just a deployment — it reflects a **real-world architecture design**, incorporating enterprise constraints, trade-offs, and operational considerations.

---

## Architecture Principles

### 🔹 High Availability

- Active deployment across:
  - East US  
  - West Europe  
- Global failover using Azure Front Door  
- Regional redundancy via Application Gateway  

---

### 🔹 Zero Trust (Layered Security)

A **defense-in-depth strategy** is implemented:

- **Azure Front Door Premium**
  - Global entry point  
  - WAF (OWASP + bot protection)  

- **Azure Application Gateway (WAF v2)**
  - Regional Layer 7 protection  

- **Azure Firewall (Virtual WAN Hub)**
  - Centralized traffic inspection  
  - East-West and outbound traffic control  

---

### 🔹 Scalability

- Global load balancing via Front Door origin groups  
- Regional autoscaling using Application Gateway  
- Modular Terraform design for reuse and extensibility  

---

### 🔹 Network Segmentation

Hub-and-spoke model with dedicated subnets:

- App Gateway subnet  
- Web subnet  
- Application subnet  
- Data subnet  
- AzureFirewallSubnet  

---

### 🔹 Private Workloads

- No public IPs assigned to backend VMs  
- Traffic enters only through controlled entry points  
- Fully isolated internal workloads  

---

### 🔹 Observability

Centralized monitoring using **Azure Log Analytics**:

- Diagnostic settings enabled for:
  - Azure Firewall  
  - Application Gateway  
  - Virtual Machines  

---

### 🔹 Infrastructure as Code

- Fully modular Terraform architecture  
- Environment separation (DEV vs PROD)  
- CI/CD pipeline includes:
  - Security scanning (Checkov)  
  - Approval gates  
  - Drift awareness  

---

## Actual Traffic Flow (Critical Insight)

> **Important:** Azure Firewall is not inline by default.

### Real Traffic Flow (as deployed)

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
Azure Firewall (Centralized Security) *(conditional)*  

---

### Firewall Behavior

Azure Firewall is primarily used for:

- East-West traffic (between VNets)  
- Controlled outbound traffic (egress)  
- Traffic inspection when routing is enforced  

Traffic flows through the firewall **only when explicitly configured via**:

- User Defined Routes (UDRs)  
- Routing Intent  

---

## High-Level Architecture

**Global Layer**
- Azure Front Door Premium  
  - Global load balancing  
  - WAF protection  
  - Private Link to Application Gateways  

---

**Regional Layer (Active-Active)**

Each region (East US & West Europe) includes:

- Application Gateway (WAF v2)  
- Spoke VNet with:
  - App Gateway subnet  
  - Web subnet  
  - Application subnet  
  - Data subnet  
- Private VM workloads  

---

**Core Networking Layer**

- Azure Virtual WAN (global backbone)  
- Virtual Hubs per region:
  - Azure Firewall (Premium)  
  - VPN Gateway  
- Hub-to-hub connectivity  

---

**Observability Layer**

- Log Analytics Workspace:
  - Firewall logs  
  - VM metrics  
  - Diagnostic logs  

---

## Key Architectural Realities (Interview Focus)

### 🔹 Firewall Placement
- Deployed in Virtual WAN hub  
- Not inline between Application Gateway and backend  

---

### 🔹 Routing Dependency
Firewall inspection depends on:

- Routing Intent  
- User Defined Routes (UDRs)  

---

### 🔹 Secure Ingress
- Azure Front Door connects to Application Gateway via **Private Link**  
- No direct public exposure of backend services  

---

### 🔹 Private Compute
- VMs have no public IPs  
- Access controlled through layered entry points  

---

## Design Trade-Offs

| Decision | Benefit | Trade-Off |
|----------|--------|----------|
| Multi-region deployment | High availability | Increased cost |
| Layered security | Strong protection | Added complexity |
| Virtual WAN | Simplified global routing | Higher baseline cost |
| Front Door + App Gateway | Global + regional control | More components |

---

## What Makes This Architecture Strong

- Real enterprise-grade design (not demo-level)  
- Aligns with Azure Well-Architected Framework  
- Implements Zero Trust principles  
- Demonstrates FinOps awareness  
- Built with production-grade CI/CD practices  

---

## Next Steps (Future Enhancements)

- End-to-end TLS using Azure Key Vault  
- Advanced routing policies (UDR + routing intent)  
- Private service integrations (Private Endpoints)  
- Autoscaling optimization based on real traffic  
- Cost optimization using telemetry and usage data  

---

## Final Summary

This architecture demonstrates:

- Multi-region resilient design  
- Layered Zero Trust security  
- Hub-and-spoke networking via Virtual WAN  
- Fully private backend workloads  
- Centralized monitoring and observability  
- Infrastructure as Code using Terraform  
- FinOps-aligned cost awareness  

---

## Author Insight

I designed a multi-region Azure architecture using Virtual WAN with a layered security model combining Front Door, Application Gateway, and Azure Firewall.

I ensured workloads remained private, implemented centralized observability, and automated deployments using Terraform with approval gates and security scanning.

A key design consideration was understanding that **firewall inspection depends on explicit routing configuration**, not default traffic flow — a critical distinction in real-world Azure networking.
