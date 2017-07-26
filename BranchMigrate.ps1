Param(
    [string]$branches
)
if (-not($branches))
{
    Throw "You must Provide a list of branches"
}
$upName = "upstream_old"
If ($(git remote -v | Select-String $upName))
{
    git remote set-url $upName https://msazure.visualstudio.com/DefaultCollection/One/_git/ServiceBus-DeviceHub
}
Else
{
    git remote add $upName https://msazure.visualstudio.com/DefaultCollection/One/_git/ServiceBus-DeviceHub
}


#set the new origin
git remote set-url origin https://msazure.visualstudio.com/DefaultCollection/One/_git/Azure-IoT-Hub-Main

#rename the repo root
cd ../
rename-item ./ServiceBus-DeviceHub Azure-IoT-Hub-Main
cd Azure-IoT-Hub-Main


#finagle list of branches
git pull --quiet
git fetch $upName --quiet
$branches = $branches.Split(',')
#push branches to new root
foreach ($branchName in $branches){
    Write-Host "Attempting to copy $branchName to Azure-IoT-Hub-Main."
    git checkout $upstream_old/$branchName
    git checkout -b $branchName
    git push origin $branchName
}

