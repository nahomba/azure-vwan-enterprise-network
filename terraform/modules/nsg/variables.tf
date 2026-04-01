variable "name" {
  description = "Name of the NSG"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet IDs to associate with NSG"
  type        = map(string)
}

variable "tags" {
  description = "Tags for the NSG"
  type        = map(string)
  default     = {}
}