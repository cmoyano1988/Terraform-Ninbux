#Create a resource group
resource "azurerm_resource_group" "nimbux-rg" {
    name = "${var.project}-${var.env}-rg"
    location = var.location
}
