Param(
	[string]$branches = $(git branch).ToString().Replace("* ", "origin/")
)

$upName = "upstream_new"
If ($(git remote -v | Select-String $upName))
{
	git remote -v | Select-String $upName
}
Else
{
	git remote add $upName https://msazure.visualstudio.com/DefaultCollection/One/_git/Azure-IoT-Hub-Main
}

#$branches = $(git branch -r | Select-String -NotMatch "\->" | Select-String "origin" ) 

$branches = $branches.Split(',')

git pull origin
foreach ($remote in $branches){
	$origin, $repoName = $remote.ToString().Split('//',2)
	Write-Host "Attempting to copy $repoName to Azure-IoT-Hub-Main."
	#git branch --track $repoName $origin/$repoName
	git checkout $repoName
	git push $upName $repoName
}
