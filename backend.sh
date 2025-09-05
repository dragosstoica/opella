#!/bin/bash

RESOURCE_GROUP_NAME=opella-tfstate-rg
STORAGE_ACCOUNT_NAME=opellatfstatedgs00112233 #tfstate713   #Unique Name
CONTAINER_NAME=tfstate #tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME