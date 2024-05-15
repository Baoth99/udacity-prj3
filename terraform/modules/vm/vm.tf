resource "azurerm_network_interface" "nic" {
  name                = "${var.application_type}-${var.resource_type}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_groups}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = ""
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${var.public_ip}"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.application_type}-${var.resource_type}-internal"
  location            = "${var.location}"
  resource_group_name = "${var.resource_groups}"
  size                = "Standard_DS2_v2"
  admin_username      = "devop03"
  network_interface_ids = [azurerm_network_interface.nic.id]
  admin_ssh_key {
    username   = "devop03"
    public_key = file("${path.module}/id_rsa.pub")
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
