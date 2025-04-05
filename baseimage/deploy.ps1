# Resource group and ACR details
$rg = "dev"
$image_name = "baseimage"
$acrname = "devacrmrbit2411"
$tag = "pwsh-python"
$container_name = "devcont001"

# Optionally create ACR if it doesn't exist
$create_acr = $true
$create_container = $true
if ($create_acr) {
    az acr create --resource-group $rg --name $acrname --sku Basic --admin-enabled true
}

# Login to ACR, build the image, tag it, and push to ACR
az acr login --name $acrname
docker build -t $tag .
$image = "$($acrname).azurecr.io/$($image_name):latest"
docker tag $tag $image
docker push $image

if($create_container){
  # Deploy a container group using the uploaded image
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
  # we do not start it here, that just on the creation phase, we are now updating
}