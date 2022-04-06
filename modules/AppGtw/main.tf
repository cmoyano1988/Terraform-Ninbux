resource "azurerm_application_gateway" "nimbux-appgtw" {
  name                = "${var.project}-${var.env}-app-gtw"
  resource_group_name = azurerm_resource_group.nimbux-rg.name
  location            = azurerm_resource_group.nimbux-rg.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_VM1
    frontend_ip_configuration_name = local.frontend_ip_VM1
    frontend_port_name             = local.frontend_port_VM1
    protocol                       = "Http"
    name                           = local.listener_VM2
    frontend_ip_configuration_name = local.frontend_ip_VM2
    frontend_port_name             = local.frontend_port_VM2
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}
resource "azurerm_public_ip" "nimbux-public-ip" {
  name                = "example-pip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Dynamic"
}