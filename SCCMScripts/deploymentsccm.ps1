New-CMApplication -Name “Google Chrome” -Description “Chrome Web Browser” -AutoInstall $true

Add-CMMsiDeploymentType -ApplicationName “Google Chrome” -ContentLocation “\\cmshare\source files\google chrome\googlechromestandaloneenterprise64.msi” -InstallationBehaviorType InstallForSystem

Start-CMContentDistribution -ApplicationName “Google Chrome” -DistributionPointGroupName “DP Group” -Verbose
New-CMApplicationDeployment -CollectionName “Deploy Google Chrome” -Name “Google Chrome” -DeployAction Install -DeployPurpose Available -UserNotification DisplayAll -AvailableDateTime (get-date) -TimeBaseOn LocalTime -Verbose