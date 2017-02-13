Function CalcBrickName {
Param(
$ApplicationName,
$AppVersion,
$Type,
$Remark,
$Arch,
$Lang,
$OS,
$path
)

	$script:strAppName = $ApplicationName -replace " ",""
	$script:strAppVer = $AppVersion -replace "\.",""
	$script:strAppVer = $script:strAppVer -replace " ",""
	$strType = ""



	if ($Type -eq "MSI") {
		$strType = ""
	}
	elseif ($Type -eq "App-V 4") {
		$strType = "-AV"
	}
	elseif ($Type -eq "App-V 5") {
		$strType = "-AV5"
	}
	elseif ($Type -eq "App-V 5 Connection Group") {
		$strType = "-CG"
	}
	elseif ($Type -eq "ThinApp") {
		$strType = "-TA"
	}
	elseif ($Type -eq "Mac") {
		$strType = "-MAC"
	}
	elseif ($Type -eq "Scripted") {
		$strType = ""
	}
	elseif ($Type -eq "App-V Version TBD"){
    $strType = "App-V Version TBD"
    }
    else{
    $strType = "Non Valid Package Type"
    }
	


#	if ($Customer.Text -eq "British Broadcasting Corporation" ) {
		#$checked=$Targets.CheckedItems
		#foreach ($item in $checked) {
		#	if ($item -eq "Windows Server 2003 32 Bit" -or $item -eq "Windows Server 2008") {$Remark.text = "TS"}
		#}
#		$TerminalServer = IsTerminalServer
#		if ($Customer.Text -eq "British Broadcasting Corporation" -and $TerminalServer) {
#			$Remark.text = "TS"
#		}
#	}

	if ($Remark.Length -gt 1) {$strRemark = "-" + $Remark} else {$strRemark = ""}
	$strRemark = $strRemark -replace " ",""


	$a = $Arch
	if ($Arch -eq "X64 (64 Bit)") {$strArch = "-" + $a.ToString().substring(0,3).ToLower()} else {$strArch = ""}
	$a = $null

	$strLang = ""
	if ($Lang -eq "English") {$strLang = ""}
	if ($Lang -eq "Welsh") {$strLang = "-CY"}
	if ($Lang -eq "German") {$strLang = "-DE"}
	if ($Lang -eq "Austrian") {$strLang = "-AT"}
	if ($Lang -eq "French") {$strLang = "-FR"}
	if ($Lang -eq "Spanish") {$strLang = "-ES"}
	if ($Lang -eq "Japanese") {$strLang = "-JA"}
	if ($Lang -eq "Italian") {$strLang = "-IT"}
	if ($Lang -eq "Danish") {$strLang = "-DA"}
	if ($Lang -eq "Portuguese") {$strLang = "-PT"}
	if ($Lang -eq "Swedish") {$strLang = "-SV"}
	if ($Lang -eq "Korean") {$strLang = "-KO"}
	if ($Lang -eq "Chinese") {$strLang = "-ZH"}
	if ($Lang -eq "Norwegian") {$strLang = "-NO"}
	if ($Lang -eq "Finnish") {$strLang = "-FI"}

   

 	$strLowestValue = $OS
		#Write-Host "Lowest Value from all selected >"$strLowestValue"<"
	
	if ($strLowestValue -ne "" -and $strLowestValue -ne $null -and $strLowestValue -ne 99) {$strOS = "-" + [string]$strLowestValue} else {$strOS=""}
	#write-host "Using strOS >$strOS< with lowestvalue of >$strLowestValue<"


$brickname = $strAppName + "-" + $strAppVer + $strType + $strRemark + $strArch + $strLang + $strOS + "-R01" +"-B01"
If($brickname.length -gt 50){
$strAppName = "Brick Name To Long"
}

IF(($script:strAppVer.Length) -gt 9){
$strAppVer = "Max 9 Characters"}

IF(($Arch -eq "X64 (64 Bit)") -or ($Arch -eq "X86 (32 Bit)")){}else{
$strArch = "-Architecture must match  'X64 (64 Bit)' or 'X86 (32 Bit)'"
}

	
IF($path -eq $null){
    $brickname = $strAppName + "-" + $strAppVer + $strType + $strRemark + $strArch + $strLang + $strOS + "-R01" +"-B01"
	Return $brickname
}else{
$bricknamefolder = $strAppName + "-" + $strAppVer + $strType + $strRemark + $strArch + $strLang + $strOS + "\R01" + "-B01"
Return $bricknamefolder
}	
}





$strSharePointSiteURL = "https://uam.ms.myatos.net/"
$newarray  =@()
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")
    $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($strSharePointSiteURL)
    [System.Net.CredentialCache]$credentials = New-Object -TypeName System.Net.CredentialCache
    $ctx.Credentials = $credentials.DefaultNetworkCredentials;
    $ctx.RequestTimeOut = 5000 * 60 * 10
    $web = $ctx.Web
    $list = $web.Lists.GetByTitle("Application Tracker")
    $camlQuery = New-Object Microsoft.SharePoint.Client.CamlQuery
    $camlQuery.ViewXml = "<View>
<Query>
<Where>
  <Eq>
    <FieldRef Name='Client'></FieldRef>
    <Value Type='Text'>National Savings and Investments</Value>
  </Eq>
</Where>
</Query>
<RowLimit>1000</RowLimit>
</View>"
    $spListItemCollection = $List.GetItems($camlQuery)
    $ctx.Load($spListItemCollection)
    $ctx.ExecuteQuery()
    foreach ($item in $spListItemCollection){
        $1 = $item['Title']
        $2 = $item['ApplicationStatus']       
        $3 = $item['ApplicationVendor0']
        $3 = $3.LookupValue;
        $4 = $item['ApplicationName']
        $5 = $item['ApplicationVersion']
        $6 = $item['PackageArchitecture']
        $7 = $item['Complexity']
        $9 = $item['Package_x0020_archive_x0020_name']
        $10 = $item['Package_x0020_Remark']

        $newarray += New-Object PsObject -Property @{
        
        Title = $1 ;
        Application_x0020_status = $2  ;   
        Application_x0020_Vendor = $3;
        Application_x0020_name = $4;
        Application_x0020_version = $5;
        Package_x0020_architecture = $6;
        Complexity = $7;
        Package_x0020_archive_x0020_name = $9;
        Remark = $10;
        
        
        }




       }



$array2 =@()

Foreach($item in $newarray){

$newBrickname = CalcBrickName -ApplicationName $item.Application_x0020_name -AppVersion $item.Application_x0020_version -Type "App-V 5" -Remark $item.Remark -Arch  $item.Package_x0020_architecture -Lang "English" -OS "63" -path $null
$array2 += $item|Select-Object *,@{Name='NewBrickName';Expression={"$newBrickname"}}
   

}






$array2 |Export-Csv -Path "C:\uam\NSIfinal.csv"












$newarray |Export-Csv -Path "C:\Users\a583418\Desktop\finalexport.csv"