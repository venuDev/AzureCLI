#!/bin/bash
location="eastus"
randomIdentifier=ngp589

resource="resource$randomIdentifier"
server="server$randomIdentifier"
database="database$randomIdentifier"
blobaccount="azblob$randomIdentifier"
resourcegroupid="learn-948f8dad-bf27-48f2-b535-7f034439e5f9"
adfname="azadf$randomIdentifier"

login="rootuser"
password="Root(24)"

startIP=0.0.0.0
endIP=0.0.0.0

echo "Creating $resource..."
#az group create --name $resource --location "$location"
echo "Creating $blobaccount..."
az storage account create -g $resourcegroupid  -n $blobaccount -l $location --sku Standard_LRS
echo "Creating $server in $location..."
az sql server create --name $server -g $resourcegroupid --location "$location" --admin-user $login --admin-password $password

echo "Configuring firewall..."
az sql server firewall-rule create -g $resourcegroupid --server $server -n AllowYourIp --start-ip-address $startIP --end-ip-address $endIP

echo "Creating $database on $server..."
az sql db create -g $resourcegroupid --server $server --name $database --sample-name AdventureWorksLT 
# zone redundancy is only supported on premium and business critical service tiers

az datafactory factory create -n $adfname -g $resourcegroupid -l $location
