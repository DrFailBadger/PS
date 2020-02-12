
Get-ADOrganizationalUnit -Filter *
$Query = "select SMS_R_USER.ResourceID,SMS_R_USER.ResourceType,SMS_R_USER.Name,SMS_R_USER.UniqueUserName,SMS_R_USER.WindowsNTDomain from SMS_R_User where SMS_R_User.department = '$($Group)'"

$GroupName = "GG_fallen_7-zip_11.2_G_AppV_install"
$Ou = "users"
$path =“OU=AppV,OU=SoftwareGroups,OU=SCCM,DC=contoso,DC=com” 

NEW-ADGroup –name $GroupName -GroupCategory Security –groupscope Global –path $path
Add-ADGroupMember -Identity $GroupName -Members testuser01,testuser02

$Sched = New-CMSchedule -DayOfWeek Sunday
$LimitingCollections = "All Users"
$query1 = "select SMS_R_USER.ResourceID,SMS_R_USER.ResourceType,SMS_R_USER.Name,SMS_R_USER.UniqueUserName,SMS_R_USER.WindowsNTDomain from SMS_R_User where SMS_R_User.UserGroupName = `"Contoso\\$GroupName`""

New-CMUserCollection -Name $GroupName -LimitingCollectionName $LimitingCollections -RefreshSchedule $Sched
Sleep 1
Add-CMUserCollectionQueryMembershipRule -CollectionName $GroupName -QueryExpression $Query1 -RuleName $GroupName