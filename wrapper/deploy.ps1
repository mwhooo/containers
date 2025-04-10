# Resource group and ACR details
param(
  [Parameter(Mandatory=$false)][string]$acrname = "devacrmrbit2411",
  [Parameter(Mandatory=$false)][string]$container_name,
  [Parameter(Mandatory=$true)][string]$image_name,
  [Parameter(Mandatory=$false)][string]$rg = "dev",
  [Parameter(Mandatory=$true)][string]$version,
  [Parameter(Mandatory=$true)][string]$docker_folder,
  [Switch]$create_acr,
  [Switch]$create_container_group
)

#set the working directory to the location of the demo folder
$CWD = split-path $MyInvocation.MyCommand.Path -Parent
Set-Location "$CWD/../$docker_folder"

# Optionally create ACR if it doesn't exist
if ($create_acr) {
    Write-Output "Creating ACR..."
    az acr create --resource-group $rg --name $acrname --sku Basic --admin-enabled true
}

# Login to ACR, build the image, tag it, and push to ACR
Write-Output "Building and pushing image to ACR..."
$tag = $image_name
az acr login --name $acrname
docker build -t $tag .

$image = "$($acrname).azurecr.io/$($image_name):$version"
docker tag $tag $image
docker push $image

$image_latest = "$($acrname).azurecr.io/$($image_name):latest"
docker tag $tag $image_latest
docker push $image_latest

if($create_container_group){
  Write-Output "Creating container group..."
  #we need to check if the container already exists not
  $exists = (az container show --name $container_name --resource-group dev) | ConvertFrom-Json
  az container create `
    --resource-group $rg `
    --name $container_name `
    --image $image `
    --restart-policy Never `
    --cpu 1 `
    --memory 1 `
    --registry-login-server "$($acrname).azurecr.io" `
    --registry-username $(az acr credential show --name $acrname --query "username" --output tsv) `
    --registry-password $(az acr credential show --name $acrname --query "passwords[0].value" --output tsv) `
    --os-type Linux
  # improve by checking current status, on initial creation it will be "Pending" and you cant start it.
  # if the image version does not change the container wont get started, at least that is the theory for now.
  Write-output "Container group created. Starting the container..."

  # this wont suffice yet, lets check some states
  if($exists) {
    Write-Output "Container group already exists. Starting the container..."
    az container start --resource-group $rg --name $container_name
  } 

}
Set-Location $CWD
Write-Output "Deployment complete. You can check the status of the container group using the Azure portal or CLI."