# No public IP on the NIC: the VM is reachable only from inside the VNet (or via Bastion).
resource "azurerm_network_interface" "this" {
  name                = "nic-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  network_interface_ids = [azurerm_network_interface.this.id]

  # SSH key only. Passwords can be brute-forced; keys cannot.
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  # System-assigned identity lets the VM call Key Vault / Storage without stored credentials.
  identity {
    type = "SystemAssigned"
  }

  encryption_at_host_enabled = var.encryption_at_host_enabled

  # Trusted Launch: protects against boot kits and rootkits.
  secure_boot_enabled = true
  vtpm_enabled        = true

  # Azure installs security patches automatically.
  patch_mode            = "AutomaticByPlatform"
  patch_assessment_mode = "AutomaticByPlatform"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  # Empty block = managed boot diagnostics storage (no storage account to manage).
  boot_diagnostics {}

  tags = var.tags
}

# ----- Optional Azure Bastion (off by default because of cost) -----
resource "azurerm_public_ip" "bastion" {
  count = var.bastion_enabled ? 1 : 0

  name                = "pip-bas-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "this" {
  count = var.bastion_enabled ? 1 : 0

  name                = "bas-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }
}
