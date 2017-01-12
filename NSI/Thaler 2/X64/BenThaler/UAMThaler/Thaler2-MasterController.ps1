#Modify Section 

$Location = "C:\Users\a583418\Desktop\Current Project\5 - Client work\NS&I - Done\Batch Three Thalers\1.0 Done\UAMThaler"

$VMXpath = "E:\Windows 7 x86\Windows 7 x86\Windows 7 x32.vmx"
$Snapshotname = "App-v Seq 5.1"
$DefaultVMUserName = "Packaging User"
$DefaultVMPassword = "P4ckag!ng"

#Docs

$DefaultAuthor = "Benjamin Gregory"
$DefaultRequestor = "David Hislop"
$DefaultRequestorEmail = "David.Hislop@atos.net"
$DefaultRequestorTel = "077080Test"
$DefaultHostAddress = "TestAdress"
$DefaultHostPort = "TestPort"

##Do not Modify Section

$ThalerPackagingTemplate = "$Location\Thaler Packaging Template.docx"
$ThalerDiscoTemplate = "$Location\Thaler Discovery Template.docx"

$ServerPath = "\\netappnsi01a"
$ResourcePath = "$ServerPath\NSI_BO_FS1\Thaler\Thaler.dev\ThalerV2Screens"
#$ServerAppData = "$ServerPath\serverINIS"
$ServerAppData = "C:\packages\serverINIS"
$VMWorkingLocation = "C:\packages"
$ThalerENVTXT = Get-Content "$location\ENV.txt"
$DefaultThalerResourcePath = "$ResourcePath"
$ThalerVersion = '24019'



Function Create-ThalerDocs {

    [CmdletBinding()]
    Param(       
                 

        [Parameter(Mandatory=$True,
                   HelpMessage = "Location of Thaler Template Document.")]
        [ValidateScript({(Test-Path $_)})] 
        [String]$ThalerTemplate,

        [Parameter(Mandatory=$True,
                   HelpMessage = "Location to Save the Document.")]
        [ValidateScript({(Test-Path "$(Split-Path "$_")")})] 
        [String]$SaveLocation,

        [Parameter(Mandatory=$True,
                   HelpMessage = "New Thaler Environment.")] 
        [String]$ThalerENV,

        [Parameter(Mandatory=$False,
                   HelpMessage = "New Thaler HostAddress.")]
        [ValidateScript({(Test-Path $_)})] 
        [String]$ThalerHostAddress = $DefaultHostAddress,

        [Parameter(Mandatory=$False,
                   HelpMessage = "New Thaler HostPort.")]
        [String]$ThalerHostPort = $DefaultHostPort,

        [Parameter(Mandatory=$False,
                   HelpMessage = "New Thaler ResourcePath.")]
        [ValidateScript({(Test-Path $_)})] 
        [String]$ThalerResourcePath = $DefaultThalerResourcePath,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Document Author.")]
        [String]$Author = $DefaultAuthor,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Document Requestor.")]
        [String]$Requestor  = $DefaultRequestor,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Document RequestorEmail.")] 
        [String]$RequestorEmail = $DefaultRequestorEmail,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Document RequestorTel.")]
        [String]$RequestorTel = $DefaultRequestorTel,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Document RequestorTel.")]
        [String]$BrickName


)


	$script:Word = New-Object -Com Word.Application
	$Word.Visible = $True #set this to true for debugging
	# http://msdn.microsoft.com/en-us/library/bb238158%28v=office.12%29.aspx

		$Doc = $Word.Documents.Open("$ThalerTemplate")
		$Doc.Activate()
		$objRange = $Doc.BookMarks.Item("Loc_Author").Range
		$objRange.Text = "$Author"

		$objRange = $Doc.BookMarks.Item("Pg1_Packager").Range
		$objRange.Text = "$Author"

		$objRange = $Doc.BookMarks.Item("Loc_Date").Range
		$objRange.Text = "$(Get-Date -f dd/MM/yyyy)"

		$objRange = $Doc.BookMarks.Item("Pg1_Date").Range
		$objRange.Text = "$(Get-Date -f dd/MM/yyyy)"

		$objRange = $Doc.BookMarks.Item("Loc_Description").Range
		$objRange.Text = "$BrickName"

		$objRange = $Doc.BookMarks.Item("Sec1_Requestor").Range
		$objRange.Text = "$Requestor"

		$objRange = $Doc.BookMarks.Item("Sec1_RequestorEmail").Range
		$objRange.Text = "$RequestorEmail"

		$objRange = $Doc.BookMarks.Item("Sec1_RequestorTel").Range
		$objRange.Text = "$RequestorTel"

		$objRange = $Doc.BookMarks.Item("Sec2_BrickName").Range
		$objRange.Text = "$BrickName"

		$objRange = $Doc.BookMarks.Item("ThalerENV1").Range
		$objRange.Text = "$ThalerENV"

		$objRange = $Doc.BookMarks.Item("ThalerENV2").Range
		$objRange.Text = "$ThalerENV"

		$objRange = $Doc.BookMarks.Item("ThalerENV3").Range
		$objRange.Text = "$ThalerENV"

		$objRange = $Doc.BookMarks.Item("ThalerHostAddress").Range
		$objRange.Text = "$ThalerHostAddress"

		$objRange = $Doc.BookMarks.Item("ThalerHostPort").Range
		$objRange.Text = "$ThalerHostPort"

		$objRange = $Doc.BookMarks.Item("ThalerResourcePath").Range
		$objRange.Text = "$ThalerResourcePath"

		$objRange = $Doc.BookMarks.Item("ThalerHostAddress1").Range
		$objRange.Text = "$ThalerHostAddress"

		$objRange = $Doc.BookMarks.Item("ThalerHostPort1").Range
		$objRange.Text = "$ThalerHostPort"

		$objRange = $Doc.BookMarks.Item("ThalerResourcePath1").Range
		$objRange.Text = "$ThalerResourcePath"



		$Doc.SaveAs([ref]$SaveLocation)
    	$Doc.Close()	

    
    $Word.quit()
    $Word = $null
   	

}

Function Create-ThalerDiscoDocs {

    [CmdletBinding()]
    Param(       
                 

        [Parameter(Mandatory=$True,
                   HelpMessage = "Location of Thaler Template Document.")]
        [ValidateScript({(Test-Path $_)})] 
        [String]$ThalerDiscoTemplate,

        [Parameter(Mandatory=$True,
                   HelpMessage = "Location to Save the Document.")]
        [ValidateScript({(Test-Path "$(Split-Path "$_")")})] 
        [String]$SaveLocation,

        [Parameter(Mandatory=$True,
                   HelpMessage = "New Thaler Environment.")] 
        [String]$ThalerENV,

        [Parameter(Mandatory=$False,
                   HelpMessage = "New Thaler HostAddress.")]
        [ValidateScript({(Test-Path $_)})] 
        [String]$ThalerHostAddress = $DefaultHostAddress,

        [Parameter(Mandatory=$False,
                   HelpMessage = "New Thaler HostPort.")]
        [String]$ThalerHostPort = $DefaultHostPort,

        [Parameter(Mandatory=$False,
                   HelpMessage = "New Thaler ResourcePath.")]
        [ValidateScript({(Test-Path $_)})] 
        [String]$ThalerResourcePath = $DefaultThalerResourcePath,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Document Author.")]
        [String]$Author = $DefaultAuthor,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Document Requestor.")]
        [String]$Requestor  = $DefaultRequestor,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Document RequestorEmail.")] 
        [String]$RequestorEmail = $DefaultRequestorEmail,

        [Parameter(Mandatory=$False,
                   HelpMessage = "Document RequestorTel.")]
        [String]$RequestorTel = $DefaultRequestorTel


)


	$script:Word = New-Object -Com Word.Application
	$Word.Visible = $True #set this to true for debugging
	# http://msdn.microsoft.com/en-us/library/bb238158%28v=office.12%29.aspx

		$Doc = $Word.Documents.Open("$ThalerDiscoTemplate")
		$Doc.Activate()

		$objRange = $Doc.BookMarks.Item("Loc_Author").Range
		$objRange.Text = "$Author"

		$objRange = $Doc.BookMarks.Item("Pg1_Packager").Range
		$objRange.Text = "$Author"

		$objRange = $Doc.BookMarks.Item("Loc_Date").Range
		$objRange.Text = "$(Get-Date -f dd/MM/yyyy)"

		$objRange = $Doc.BookMarks.Item("Loc_Date1").Range
		$objRange.Text = "$(Get-Date -f dd/MM/yyyy)"

		$objRange = $Doc.BookMarks.Item("Pg1_Date").Range
		$objRange.Text = "$(Get-Date -f dd/MM/yyyy)"

		$objRange = $Doc.BookMarks.Item("Sec1_Requestor").Range
		$objRange.Text = "$Requestor"

		$objRange = $Doc.BookMarks.Item("Sec1_Requestor1").Range
		$objRange.Text = "$Requestor"

		$objRange = $Doc.BookMarks.Item("Sec1_RequestorEmail").Range
		$objRange.Text = "$RequestorEmail"

		$objRange = $Doc.BookMarks.Item("Sec1_RequestorTel").Range
		$objRange.Text = "$RequestorTel"

		$objRange = $Doc.BookMarks.Item("ThalerENV1").Range
		$objRange.Text = "$ThalerENV"

		$objRange = $Doc.BookMarks.Item("ThalerENV2").Range
		$objRange.Text = "$ThalerENV"

		$objRange = $Doc.BookMarks.Item("ThalerENV3").Range
		$objRange.Text = "$ThalerENV"

		$objRange = $Doc.BookMarks.Item("ThalerENV4").Range
		$objRange.Text = "$ThalerENV"

		$objRange = $Doc.BookMarks.Item("ThalerENV5").Range
		$objRange.Text = "$ThalerENV"

		$objRange = $Doc.BookMarks.Item("ThalerENV6").Range
		$objRange.Text = "$ThalerENV"

		$objRange = $Doc.BookMarks.Item("ThalerHostAddress").Range
		$objRange.Text = "$ThalerHostAddress"

		$objRange = $Doc.BookMarks.Item("ThalerHostPort").Range
		$objRange.Text = "$ThalerHostPort"

		$objRange = $Doc.BookMarks.Item("ThalerResourcePath").Range
		$objRange.Text = "$ThalerResourcePath"

		$objRange = $Doc.BookMarks.Item("ThalerHostAddress1").Range
		$objRange.Text = "$ThalerHostAddress"

		$objRange = $Doc.BookMarks.Item("ThalerHostPort1").Range
		$objRange.Text = "$ThalerHostPort"

		$objRange = $Doc.BookMarks.Item("ThalerResourcePath1").Range
		$objRange.Text = "$ThalerResourcePath"



		$Doc.SaveAs([ref]$SaveLocation)
    	$Doc.Close()	

    
    $Word.quit()
    $Word = $null
   	

}


Foreach ($ThalerENV in $ThalerENVTXT){

    $Brickname = "Thaler-$ThalerVersion-AV5-$ThalerENV-63-R01-R01"
    $PackageLocation = "$Location\Thaler-$ThalerVersion-AV5-$ThalerENV-63\R01-R01"

    MD "$PackageLocation\Documents" -Force
    MD "$PackageLocation\Installation" -Force
    MD "$PackageLocation\Source" -Force

    Start-VMSnapshots -Snapshots revertToSnapshot -SnapshotName "$Snapshotname" -VMXpath $VMXpath

    Start-Sleep -seconds 40     

    $SequencerVersion = Invoke-VMPSCommand -VMXpath $VMXpath -Command "

    Write-Progress -Activity `"Thaler Capture`" -percentComplete 0 -Status `"Starting Copy`"
    
    MD `"C:\Packages`" -erroraction `"Silentlycontinue`"
    
    Copy-Item -Path `"$(`"$Location\Thaler`".Replace(`"C:\`",`"Z:\c\`"))`" -Destination `"$VMWorkingLocation`" -recurse

    Write-Progress -Activity `"Thaler Capture`" -percentComplete 10 -Status `"Creating Installer`"

    set-Content -Path `"C:\Packages\Thaler\Install.cmd`" -Value '`"C:\Packages\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`" -file `"$VMWorkingLocation\Thaler\Thaler-$ThalerVersion-installer.ps1`" -ThalerENV $ThalerENV -PackageFolder `"$VMWorkingLocation\Thaler`" -ServerAppData `"$ServerAppData`"`' | Out-null
    
    Write-Progress -Activity `"Thaler Capture`" -percentComplete 30 -Status `"Capturing Thaler`"

    New-AppvSequencerPackage -FullLoad -Installer `"$VMWorkingLocation\Thaler\install.cmd`" -TemplateFilePath `"$VMWorkingLocation\Thaler\Atos.appvt`" -Name `"Thaler-$ThalerVersion-AV5-$ThalerENV-63-R01-R01`" -Path `"$VMWorkingLocation\Thaler\Output`" -Verbose | Out-Null
   
    Write-Progress -Activity `"Thaler Capture`" -percentComplete 70 -Status `"Copying Back`"

    Copy-Item -Path `"$VMWorkingLocation\Thaler\Output\*`" -Destination `"$(`"$PackageLocation\Installation`".Replace(`"C:\`",`"Z:\c\`"))`" -recurse

    Write-Progress -Activity `"Thaler Capture`" -percentComplete 100 -Status `"Done`"

    " -PSReturnVariable '$Return' -Visible True -ErrorAction SilentlyContinue


    Create-ThalerDocs -ThalerTemplate "$ThalerPackagingTemplate" -SaveLocation "$PackageLocation\Documents\UAMID Package Build $Brickname.docx" -ThalerENV "$ThalerENV" -BrickName "$Brickname" 

    Create-ThalerDiscoDocs -ThalerDiscoTemplate "$ThalerDiscoTemplate" -SaveLocation "$PackageLocation\Documents\UAMID Application Discovery $Brickname" -ThalerENV "$ThalerENV"

}










