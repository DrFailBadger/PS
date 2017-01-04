$Path = dir "C:\MCT\Zip"
#$path | where {if ($_.BaseName -match "-")}

foreach ($item in $Path){
    $changeName1 =$item.FullName.Replace("-", "_")
    Rename-Item $item.fullname $changeName1
}

$Coverted = dir "C:\MCT\Captured"


Foreach ($MSI in $converted){
     $changemsi = $item.BaseName.replace("-", "_")+".msi"
     Rename-Item $item.fullname $changeName
}

Clear-Variable item