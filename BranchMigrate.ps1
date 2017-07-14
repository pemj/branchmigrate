Param(
	[string]$branches = "blank"
)

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
if ($branches.equals("blank"))
{
	#get a list of this user's branches
	$branches = -split $(git for-each-ref --format='%09 %(authoremail) %09 %(refname)' | Select-String "$(git config --global user.email)") | Select-String "refs/remotes/$upName"
}
Else
{
	$branches = $branches.Split(',')
}
Write-Host "list of branches is as follows: $branches"
#push branches to new root
foreach ($remote in $branches.split()){
	$repoName, $branchName = $remote.ToString().Replace("refs/remotes/", "").Split('/',2)
	Write-Host "Attempting to copy $branchName to Azure-IoT-Hub-Main."
	git branch --track $repoName/$branchName
	git checkout $branchName
	git push origin $branchName
}

