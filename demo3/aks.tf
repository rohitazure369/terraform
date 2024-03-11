resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.${var.rg_location}.azmk8s.io"
  resource_group_name = var.rg_name
}


resource "azurerm_user_assigned_identity" "uai" {
  name                = "aks-${var.env}-identity"
  resource_group_name = var.rg_name
  location            = var.rg_location
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


}


# Allow AKS access to pull images from ACR
resource "azurerm_role_assignment" "acr_aks_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}