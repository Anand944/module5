resource "azurerm_resource_group" "resorcegroup" {
  name     = "rm07"
  location = "East us"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet01"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_interface" "nic" {
  name                = "nic01"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "vm01"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  size                = "Standard_F2"
  admin_username      = "adm-anand"
  admin_password      = "Siddu@20222022"
  network_interface_ids = [
    azurerm_network_interface.resourcegroup.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}