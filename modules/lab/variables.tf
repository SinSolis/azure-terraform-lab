variable "vmname" {}

variable "rgname" {}

variable "rgnetwork" {}

variable "vnetname" {}

variable "subnetname" {}

variable "location" {}

variable "vmsize" {
    default = "Standard_A4_v2"
}

variable "image_sku" {
    default = "18.04-LTS"
}

variable "osdiskcaching"{
    default = "ReadWrite"
}

variable "osdiskstoragetype"{
    default = "Premium_LRS"
}

variable "tag" {}
