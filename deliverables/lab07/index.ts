import * as pulumi from "@pulumi/pulumi";
import * as azure_native from "@pulumi/azure-native";

const clientConfig = azure_native.authorization.getClientConfigOutput();
const subscriptionId = clientConfig.apply(config => config.subscriptionId);
const id = pulumi.interpolate`/subscriptions/${subscriptionId}/resourceGroups/rg-lab7`;

const pricing = new pulumi.Config().require("staticWebAppPricing");

const resourceGroup = azure_native.resources.ResourceGroup.get("rg-lab7", id);
const environment = pulumi.getStack();

const staticSite = new azure_native.web.StaticSite("staticSite", {
    branch: "master",
    name: pulumi.interpolate`stapp-2048-app-${environment}`,
    repositoryUrl: "https://github.com/placeholder/placeholder",
    location: "westeurope",
    resourceGroupName: resourceGroup.name,
    sku: {
        name: pricing,
        tier: pricing,
    },
});

const listStaticSiteSecretsOutput = azure_native.web.listStaticSiteSecretsOutput({
    resourceGroupName: resourceGroup.name,
    name: staticSite.name,
});

export const resourceGroupName = resourceGroup.name;
export const deploymentToken = pulumi.secret(listStaticSiteSecretsOutput.apply(secrets => secrets?.properties?.apiKey));