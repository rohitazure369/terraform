 variable "env" {
    type = string
 }


variable "rg_name" {
    type = string
}

variable "rg_location" {
    type= string
 }

 variable "acr_name" {
    type= string
 }


 variable "vnet_name" {
    type = string
 }

 variable "vnet_address_space" {
    type = list(string)
 }


 variable "aks_node_count" {
    type = number
 }
 