resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.${var.rg_location}.azmk8s.io"
  resource_group_name = var.rg_name
}


# Commenting below
<<EOF

resource "azurerm_user_assigned_identity" "private_dns" {
  name                = "aks-${var.env}-identity"
  resource_group_name = var.rg_name
  location            = var.rg_location
}

resource "azurerm_role_assignment" "role_assign" {
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.private_dns.principal_id
}

EOF
# comment end


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

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }

  depends_on = [
    azurerm_role_assignment.role_assign,
  ]


}
