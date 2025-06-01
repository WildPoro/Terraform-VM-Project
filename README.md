# Terraform-VM-Project
Terraform configuration to provision an Ubuntu Linux VM in Azure with SSH access, including networking, NSG, and public IP setup.


This repo has my Terraform code to spin up an Ubuntu Linux VM in Azure. It sets up the basics like networking, security rules to allow SSH, and links my SSH key so I can connect without a password.

What it does:

Creates a resource group and virtual network

Sets up a subnet and network interface with a public IP

Opens port 22 so I can SSH into the VM

Deploys an Ubuntu 18.04 VM with my SSH key for login

What you need installed:

Terraform installed on your machine

An Azure subscription ID

An SSH key pair to connect to the VM (you can generate one by typing "ssh-keygen -t rsa -b 4096" in the terminal. It will give you the location where the key is saved make sure you replcae that in the code)

How to use it: 
Clone this repo:

git clone https://github.com/WildPoro/your-repo-name.git
cd your-repo-name

Update the variables for your Azure subscription and SSH key location.

Run these commands:

terraform init

terraform apply

When it’s done, SSH into your VM with:

ssh -i ~/.ssh/terraform_key username@your-vm-ip
