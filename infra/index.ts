import * as pulumi from "@pulumi/pulumi";
import * as resources from "@pulumi/azure-native/resources";
import * as storage from "@pulumi/azure-native/storage";

// Create an Azure Resource Group
const resourceGroup = new resources.ResourceGroup("rg-lab7", {
  tags: {
    environment: "lab",
    project: "azure-pulumi",
  },
});

// Export the storage account name
export const storageAccountName = resourceGroup.name;
