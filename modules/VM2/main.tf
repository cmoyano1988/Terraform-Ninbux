resource "azurerm_virtual_network" "nimbux-vnet" {
  name                = "${var.project}-${var.env}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.nimbux-rg.location
  resource_group_name = azurerm_resource_group.nimbux-rg.name
}

resource "azurerm_subnet" "nimbux-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.nimbux-rg.name
  virtual_network_name = azurerm_virtual_network.nimbux-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nimbux-nic" {
  name                = "${var.project}-${var.env}-nic"
  location            = azurerm_resource_group.nimbux-rg.location
  resource_group_name = azurerm_resource_group.nimbux-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.nimbux-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "nimbux-vm2" {
  name                = "${var.project}-${var.env}-vm2"
  resource_group_name = azurerm_resource_group.nimbux-rg.name
  location            = azurerm_resource_group.nimbux-rg.location
  size                = "Standard_F2"
  admin_username      = "moyano"
  network_interface_ids = [
    azurerm_network_interface.nimbux-nic.id,
  ]

  admin_ssh_key {
    username   = "ssh-moyano"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}