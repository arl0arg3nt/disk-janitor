

function TempFileHunter {
	<# Remove All User Temp Files #>
	for($i=0; $i -lt $fileNames.count; $i++){ 
		$selectedFolder = ($fileNames[$i]); 
		$selectedFolderTempPath = "$targetLocation$selectedFolder\AppData\Local\Temp\"; 
		if(Test-Path -Path $selectedFolderTempPath -ErrorAction SilentlyContinue){ 
			$TotalFilesInTargetDir = (Get-ChildItem $selectedFolderTempPath | measure).Count;
			Remove-Item "$selectedFolderTempPath\*" -recurse -ErrorAction SilentlyContinue;
			$TotalRemainingFilesInTargetDir = ($TotalFilesInTargetDir - (Get-ChildItem $selectedFolderTempPath | measure).Count);
			Write-Host "$i : $selectedFolder : $TotalRemainingFilesInTargetDir/$TotalFilesInTargetDir Files Removed in $selectedFolderTempPath"; 
		} 
		else{ 
			Write-Host "$i : No Temp Folder in $selectedFolder"; 
		}
		$selectedFolderTempPath = "$targetLocation$selectedFolder\AppData\Local\Microsoft\Windows\Temporary Internet Files"; 
		if(Test-Path -Path $selectedFolderTempPath -ErrorAction SilentlyContinue){ 
			$TotalFilesInTargetDir = (Get-ChildItem $selectedFolderTempPath | measure).Count;
			Remove-Item "$selectedFolderTempPath\*" -recurse -ErrorAction SilentlyContinue;
			$TotalRemainingFilesInTargetDir = ($TotalFilesInTargetDir - (Get-ChildItem $selectedFolderTempPath | measure).Count);
			Write-Host "$i : $selectedFolder : $TotalRemainingFilesInTargetDir/$TotalFilesInTargetDir Files Removed in $selectedFolderTempPath"; 
		} 
		else{ 
			Write-Host "$i : No Temporary Internet Files Found in $selectedFolder"; 
		} 
	}
	Remove-Item $env:WINDIR\Panther\*.tmp -Recurse -ErrorAction SilentlyContinue
	
	<# Remove Windows Temp Files #>
	$selectedFolderTempPath = "$env:WINDIR\Temp\";
	if(Test-Path -Path $selectedFolderTempPath -erroraction 'silentlycontinue'){ 
		$TotalFilesInTargetDir = (Get-ChildItem $selectedFolderTempPath | measure).Count;
		Remove-Item $selectedFolderTempPath -recurse -erroraction 'silentlycontinue'; 
		$TotalRemainingFilesInTargetDir = ($TotalFilesInTargetDir - (Get-ChildItem $targetLocation | measure).Count);
		Write-Host "W : $selectedFolderTempPath : $TotalRemainingFilesInTargetDir/$TotalFilesInTargetDir Files Removed in $selectedFolderTempPath"; 
	} 
	else{ 
		Write-Host "No Windows Temp Folder was Found"; 
	}
}