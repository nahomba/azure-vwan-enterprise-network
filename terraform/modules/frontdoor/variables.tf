# terraform/modules/frontdoor/variables.tf

variable "frontdoor_name" {
  description = "Name of the Front Door"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "enable_westeu_origin" {
  description = "Enable West Europe origin in Front Door"
  type        = bool
  default     = false
}

variable "appgw_eastus_id" {
  description = "Application Gateway ID (East US)"
  type        = string
}

variable "appgw_westeu_id" {
  description = "Application Gateway ID (West Europe)"
  type        = string
  default     = ""
}