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

- **UDRs (User Defined Routes)**  
- **Routing Intent (Virtual WAN policies)**  

Without these configurations, traffic flows **directly between resources**, bypassing the firewall.

---

## High-Level Architecture Diagram

```
                  USER / CLIENT
                       │
                       ▼
     Azure Front Door Premium (Global WAF)
                       │
        (Private Link to App Gateways)
            ┌──────────┴──────────┐
            │                     │
            ▼                     ▼
 App Gateway (East US)   App Gateway (West Europe)
    (WAF v2)                 (WAF v2)
            │                     │
            ▼                     ▼
 Backend VM (Private)     Backend VM (Private)
            │                     │
            └──────────┬──────────┘
                       │
                       ▼
          Azure Virtual WAN (Global Backbone)
                       │
            ┌──────────┴──────────┐
            │                     │
            ▼                     ▼
 Virtual Hub (EUS)        Virtual Hub (WEU)
            │                     │
            ▼                     ▼
     Azure Firewall        Azure Firewall
```

---

## Key Insight (Interview-Level Understanding)

A common misconception is that Azure Firewall automatically inspects all traffic.

In reality:

- Azure Firewall is **not inline by default**
- Traffic must be **explicitly routed through it**
- This is achieved using:
  - **User Defined Routes (UDRs)** in spoke VNets  
  - **Routing Intent** in Virtual WAN hubs  

# This design allows flexibility:
- You can enforce inspection where needed  
- Avoid unnecessary latency for internal trusted traffic  
- Control egress paths centrally  

This distinction is critical in real-world Azure networking and often misunderstood.
