<#  
    arl0arg3nt - disk janitor - 2024  
    
    GNU GENERAL PUBLIC LICENSE
    Version 3, 29 June 2007

    Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
    Everyone is permitted to copy and distribute verbatim copies
    of this license document, but changing it is not allowed.
#>

$ShouldCleanOldUserFiles = $false
$ShouldHuntTempFiles = $false
$ShouldIdentifyUnusedFiles = $false

<# rewrite

	Places To check
	- "C:\Windows\Temp"
	- "C:\Users\{USERNAME}\AppData\Local\Temp\"
	- "C:\Users\{USERNAME}\AppData\Local\Microsoft\Outlook"
	- "C:\Users\{USERNAME}\AppData\Local\Microsoft\Windows\Temporary Internet Files"
	$tmp = @(Get-ChildItem -Path C:\ -Filter *.tmp -Recurse -ErrorAction SilentlyContinue -Force | select FullName)
#>

function TempFileHunter {
	if (!$ShouldHuntTempFiles) { return $null; }

	$removedFiles = [System.Collections.ArrayList]@()
	[System.String]$UserResponse = "$null"
	$tempFiles = @((Get-ChildItem -Path C:\ -Filter *.tmp -Recurse -ErrorAction SilentlyContinue -Force).FullName);
	Write-Host $tempFiles.Count;
	foreach ($tempFile in $tempFiles) {
		if ([System.String]$UserResponse -ne [System.String]"a") { 
			[System.String]$UserResponse = Read-Host "$tempFile `r`nWould you like to delete this file? (y = yes, n = No, a = Yes to all) "; 
		}
		switch ($UserResponse) {
			"Y" {
				$removedFiles.Add($tempFile) *>$null;
				Remove-Item $tempFile -recurse -ErrorAction SilentlyContinue -Force;
				$UserResponse = $null
				break 
			}
			"A" {
				$removedFiles.Add($tempFile) *>$null;
				Remove-Item $tempFile -recurse -ErrorAction SilentlyContinue -Force;
				$UserResponse = "a";
				break 
			}
			"N" {
				$UserResponse = $null; 
				break 
			}
			Default {
				$UserResponse = $null; 
				break 
			}
			
		}
	}
	$UserResponse = $null;
	Write-Host $removedFiles
}

function CleanOldUserFiless {
	if (!$ShouldCleanOldUserFiles) { $null; }
	$CurrentUser = [System.String](Get-WmiObject Win32_Process -f 'Name="explorer.exe"'  | ForEach-Object  getowner  | ForEach-Object user)
	$ExclueFromClean = @("$CurrentUser", "admin", "public", "Technical")
	$FilesToSort = @(Get-ChildItem $targetLocation -Name);
	$FilesToClean = [System.Collections.ArrayList]@()
	
	foreach ($SelectedFile in $FilesToSort) {
		$_i = 1
		foreach ($Exclude in $ExclueFromClean) {
			if ($SelectedFile -notmatch $Exclude) { 
				Write-Host "testing: "$SelectedFile $Exclude
				if ($_i -eq ($ExclueFromClean.Count)) { 
					$FilesToClean.Add($SelectedFile);
					Write-Host $SelectedFile
				}
			}
			$_i++;
		}
		write-host "`r`n"
	}

	Write-Host "Not Functional";
}

function IdentifyUnusedFiles {
	if (!$ShouldIdentifyUnusedFiles) { $null; }
	Write-Host "Not Functional";
}

