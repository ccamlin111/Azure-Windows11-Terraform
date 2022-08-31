
resource "azurerm_resource_group" "RG" {
  name     = "CAC-Terraformtesting"
  location = "usgovvirginia"

}

resource "azurerm_virtual_network" "vnet" {
  name                = "TFvnet"
  address_space       = ["172.16.0.0/20"]
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
}

resource "azurerm_subnet" "TFsub" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["172.16.1.0/24"]

}

resource "azurerm_public_ip" "TFpubip" {
  name                = "TFpubip01"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "TFnic" {
  name                = "THnic01"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  ip_configuration {
    name                          = "TFnicpubconf"
    subnet_id                     = azurerm_subnet.TFsub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.TFpubip.id


  }

}
resource "azurerm_windows_virtual_machine" "TFvm" {
  name                     = "TFW11"
  computer_name            = "CACTFWIN11"
  enable_automatic_updates = "true"
  resource_group_name      = azurerm_resource_group.RG.name
  location                 = azurerm_resource_group.RG.location
  size                     = "Standard_D2s_v3"
  admin_username           = "tfadmin"
  admin_password           = "BGT%4rfvCDE#2wsx"
  network_interface_ids    = [azurerm_network_interface.TFnic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }
}
#add comments, create workspace, 