resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.${var.rg_location}.azmk8s.io"
  resource_group_name = var.rg_name
}


resource "azurerm_user_assigned_identity" "uai" {
  name                = "aks-${var.env}-identity"
  resource_group_name = var.rg_name
  location            = var.rg_location
}




resource "azurerm_role_assignment" "role_assign" {
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}



resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.env}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  dns_prefix          = "aks-${var.env}-dns"

  private_cluster_enabled = true
  private_dns_zone_id     = azurerm_private_dns_zone.aks.id

  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  # Assign the user-managed identity to the AKS cluster
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai.id]
  }

  tags = {
    Environment = "Production"
  }


  network_profile {
          dns_service_ip     = "10.100.0.10"
          docker_bridge_cidr = "172.17.0.1/16"
          load_balancer_sku  = "standard"
          network_plugin     = "azure"
          network_policy     = "calico"
          #outbound_type      = (known after apply)
          #pod_cidr           = (known after apply)
          service_cidr       = "10.100.0.0/16"
        }





}


# Allow AKS access to pull images from ACR
resource "azurerm_role_assignment" "acr_aks_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}