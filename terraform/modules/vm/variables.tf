variable "vm_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}

variable "vm_size" {
  default = "Standard_B2s"
}

variable "admin_username" {}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}