


resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.env}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  dns_prefix          = "aks-${var.env}-dns"



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