$path1 = dir "\\uamftp01.ms.uk.myatos.net\Customers\National Savings and Investments\1.APPV4.5_packages_Originals\SourceMedia\APPV"
$path2 = dir "C:\UAM\_MassConversion\New Source"

Compare-Object -ReferenceObject $path2 -DifferenceObject $path1