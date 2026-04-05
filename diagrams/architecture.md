Azure Virtual WAN Enterprise Architecture (Terraform-Aligned)
Overview
This project implements a production-grade, multi-region Azure architecture using Terraform, designed with a strong focus on:
High availability Zero Trust security Global scalability Network segmentation Observability Cost-awareness (FinOps)

This is not just a deployment — it is a real-world architecture design reflecting enterprise constraints and trade-offs.
Architecture Principles
🔹 High Availability Active deployment across: East US West Europe Global failover via Azure Front Door Regional redundancy with Application Gateway 🔹 Zero Trust (Layered Security)

Defense-in-depth strategy:
Azure Front Door Premium Global entry point WAF (OWASP + Bot protection) Azure Application Gateway (WAF v2) Regional Layer 7 protection Azure Firewall (Virtual WAN Hub) Centralized traffic inspection East-West & outbound control 🔹 Scalability Global load balancing via Front Door origin groups Regional scaling via Application Gateway autoscaling Modular Terraform design for reuse 🔹 Network Segmentation

Hub-and-spoke model with dedicated subnets:
AppGW Web App Data AzureFirewallSubnet 🔹 Private Workloads No public IPs on backend VMs Traffic enters only through controlled entry points 🔹 Observability Centralized logging via Log Analytics Diagnostic settings enabled for: Application Gateway Azure Firewall VMs 🔹 Infrastructure as Code Fully modular Terraform architecture Environment separation (DEV vs PROD) CI/CD pipeline with: Security scanning (Checkov) Approval gates Drift awareness Actual Traffic Flow (Critical Insight)

Important: Azure Firewall is not inline by default
Real Traffic Flow (as deployed)
trafficFlow
Azure Firewall is used for:
East-West traffic (between VNets) Controlled outbound traffic (egress) Traffic inspection when routing is enforced

Traffic only flows through the firewall when:

UDRs (User Defined Routes) are configured Routing intent is explicitly applied

High-Level Architecture Diagram
diagram
Detailed Architecture (Terraform-Aligned) Global Layer Azure Front Door Premium Global load balancing WAF protection Private Link to App Gateways Regional Layer (Active-Active) East US & West Europe

Each region contains:
Application Gateway (WAF v2)
Spoke VNet:
AppGW subnet Web subnet App subnet Data subnet Private VM workloads Networking Layer (Core) Azure Virtual WAN (global backbone) Virtual Hubs per region: Azure Firewall (Premium) VPN Gateway Hub-to-hub connectivity

Observability Layer
Log Analytics Workspace:
Firewall logs VM metrics Diagnostic logs Key Architectural Realities (Interview Gold) 🔹 Firewall Placement Deployed in Virtual WAN Hub Not inline between App Gateway and backend 🔹 Routing Dependency

Firewall inspection depends on:
Routing intent UDR configuration 🔹 Secure Ingress Azure Front Door → App Gateway via Private Link No direct public exposure of backend services 🔹 Private Compute

VMs:
No public IPs Accessible only through controlled layers Design Trade-Offs Decision Benefit Trade-Off Multi-region High availability Increased cost Layered security Strong protection Added complexity Virtual WAN Simplified global routing Higher baseline cost Front Door + App Gateway Global + regional control More components What Makes This Architecture Strong Real enterprise design (not demo-level) Aligns with Azure Well-Architected Framework Implements Zero Trust principles Demonstrates FinOps awareness Built with production-grade CI/CD practices Next Steps (Future Enhancements) End-to-end TLS with Azure Key Vault integration Advanced routing policies (UDR + routing intent) Private service integrations (PaaS via Private Endpoints) Autoscaling tuning based on real traffic patterns Cost optimization based on usage telemetry

Final Summary
This architecture demonstrates:
Multi-region resilient design Layered Zero Trust security Hub-and-spoke networking via Virtual WAN Fully private backend workloads Centralized monitoring and observability Infrastructure as Code with Terraform FinOps-aligned cost awareness

I designed a multi-region Azure architecture using Virtual WAN with a layered security model combining Front Door, Application Gateway, and Azure Firewall. I ensured workloads remained private, implemented observability, and automated deployment with Terraform using approval gates and security scanning. I also considered routing behavior carefully, understanding that firewall inspection depends on explicit routing configuration.
