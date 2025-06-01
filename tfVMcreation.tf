  variable "ID"{
      default = "#####################################"
  }
  variable "location"{
      default = "West US 2"
  }
  provider "azurerm"{
      features{}
      subscription_id = var.ID
  }

  resource "azurerm_resource_group" "example"{
      name = "TerraformRG"
      location = var.location
  }
  resource "azurerm_linux_virtual_machine" "VM" {
      name                  = "TerraformVM"
      location              = azurerm_resource_group.example.location
      resource_group_name   = azurerm_resource_group.example.name
      size                  = "Standard_DS1_v2"
      admin_username        = "kzotka"
      network_interface_ids = [azurerm_network_interface.nic.id]

      os_disk {
          caching              = "ReadWrite"
          storage_account_type = "Standard_LRS"
      }
      source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
          version = "latest"
      }
      admin_ssh_key {
        username = "kzotka"
        public_key = file("######################") #This is the location where your ssh private key will be saved. You need this key to be able to ssh to your VM after creation
      }
  }
  # Virtual Network
  resource "azurerm_virtual_network" "vnet" {
    name                = "TerraformVNet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.example.name
  }

  # Subnet
  resource "azurerm_subnet" "subnet" {
    name                 = "TerraformSubnet"
    resource_group_name  = azurerm_resource_group.example.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.1.0/24"]
  }

  # Network Interface
  resource "azurerm_network_interface" "nic" {
    name = "TerraformNIC"
    location = var.location
    resource_group_name = azurerm_resource_group.example.name

    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.public_ip.id
    }
  }
  # Public IP
  resource "azurerm_public_ip" "public_ip" {
    name = "TerraformPublicIP"
    location = var.location
    resource_group_name = azurerm_resource_group.example.name
    allocation_method = "Static"
  }
  #NSG
  resource "azurerm_network_security_group" "TerraformNSG" {
    name = "TerraformNSG"
    location = var.location
    resource_group_name = azurerm_resource_group.example.name
    security_rule{
      name = "SSH"
      priority = 100
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "22"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    } 
  }
  resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
    network_interface_id = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.TerraformNSG.id
  }
