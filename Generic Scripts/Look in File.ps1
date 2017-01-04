$Allconversions = Dir "C:\UAM\_MassConversion\Converted" -Recurse
$Conversionstatus =@()
Foreach($item in $Allconversions){
	$content = $null
	IF($item.BaseName -match "ConvertTestOutput"){
		$content = Get-content "$($item.FullName)"
	If($content -match "icon." ){

		$Conversionstatus += New-Object PsObject -Property @{Name = "$($item.BaseName)"; Status = "Good" ; Location = "$($item.FullName)"}  
		}else{$Conversionstatus += New-Object PsObject -Property @{Name = "$($item.BaseName)"; Status = "Bad" ; Location = "$($item.FullName)"} }

	}
}
$Conversionstatus| Sort-Object -Property status -Descending | Ft -AutoSize
