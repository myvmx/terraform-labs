
resource "azurerm_resource_group" "core" {
   name         = "core"
   location     = var.loc
   tags         = var.tags
}

resource "azurerm_virtual_network" "core"{
    name        = "core"
    tags        = var.tags
    resource_group_name = azurerm_resource_group.core.name
    location    = azurerm_resource_group.core.location
    address_space = ["10.0.0.0/16"]
    dns_servers = ["1.1.1.1","1.0.0.1"]
    subnet{
        name ="training"
        address_prefix = "10.0.1.0/24"
    }
    subnet{
        name = "dev"
        address_prefix = "10.0.2.0/24"
    }
}
resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.core.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "vpnGatewayPublicIp" {
    name = "vpnGatewayPublicIp"
    location = azurerm_resource_group.core.location
    resource_group_name = azurerm_resource_group.core.name
    allocation_method = "Dynamic"
}
/*resource "azurerm_virtual_network_gateway" "vpnGateway"{
    name = "vpnGateway"
    resource_group_name = azurerm_resource_group.core.name
    location = azurerm_resource_group.core.location
    type = "vpn"
    vpn_type = "routebased"
    enable_bgp = true
    sku = "basic"
    ip_configuration {
        name = ""
        public_ip_address_id = azurerm_public_ip.vpnGatewayPublicIp.id
        subnet_id = azurerm_subnet.GatewaySubnet.id
        
    }

}
*/
