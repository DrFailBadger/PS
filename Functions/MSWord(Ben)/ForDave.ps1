Function StartCreateDocs {

	$script:Word = New-Object -Com Word.Application
	$Word.Visible = $True #set this to true for debugging
	# http://msdn.microsoft.com/en-us/library/bb238158%28v=office.12%29.aspx
	$wdFormatDocument                    =  0
    $wdFormatDocument97                  =  0
    $script:wdFormatDocumentDefault      = 16
    $wdFormatDOSText                     =  4
    $wdFormatDOSTextLineBreaks           =  5
    $wdFormatEncodedText                 =  7
    $wdFormatFilteredHTML                = 10
    $wdFormatFlatXML                     = 19
    $wdFormatFlatXMLMacroEnabled         = 20
    $wdFormatFlatXMLTemplate             = 21
    $wdFormatFlatXMLTemplateMacroEnabled = 22
    $wdFormatHTML                        =  8
    $wdFormatPDF                         = 17
    $wdFormatRTF                         =  6
    $wdFormatTemplate                    =  1
    $wdFormatTemplate97                  =  1
    $wdFormatText                        =  2
    $wdFormatTextLineBreaks              =  3
    $wdFormatUnicodeText                 =  7
    $wdFormatWebArchive                  =  9
    $wdFormatXML                         = 11
    $wdFormatXMLDocument                 = 12
    $wdFormatXMLDocumentMacroEnabled     = 13
    $wdFormatXMLTemplate                 = 14
    $wdFormatXMLTemplateMacroEnabled     = 15
    $wdFormatXPS                         = 18
    $wdFormatOfficeDocumentTemplate      = 23 
    $wdFormatMediaWiki                   = 24
	
}

Function EndCreateDocs {

    $Word.quit()
    $Word = $null
   	
}

Function CreateAppV5Document {

	
	#### Process App-V 5 document

		$Doc = $Word.Documents.Open("$appvTemplate")
		$Doc.Activate()
		$objRange = $Doc.BookMarks.Item("HdrSec1_Title").Range
		$objRange.Text = $Vendor + " " + $ApplicationName + " " + $ApplicationVersion
		$objRange = $Doc.BookMarks.Item("HdrSec1_Version").Range
		$objRange.Text = "R01 B01"
		$objRange = $Doc.BookMarks.Item("Pg1_Title").Range
		$objRange.Text = $Vendor + " " + $ApplicationName + " " + $ApplicationVersion + "`n" + $BrickName
		$objRange = $Doc.BookMarks.Item("Pg1_Packager").Range
		$objRange.Text = $Packager
		$objRange = $Doc.BookMarks.Item("Pg1_Version").Range
		$objRange.Text = "R01 B01"
		$objRange = $Doc.BookMarks.Item("Pg1_Date").Range
		$objRange.Text = Get-Date -f "dd/MM/yyyy"
		$objRange = $Doc.BookMarks.Item("HdrSec2_Title").Range
		$objRange.Text = $Vendor + " " + $ApplicationName + " " + $ApplicationVersion
		$objRange = $Doc.BookMarks.Item("HdrSec2_Version").Range
		$objRange.Text = "R01 B01"
		$objRange = $Doc.BookMarks.Item("HdrSec3_Title").Range
		$objRange.Text = $Vendor + " " + $ApplicationName + " " + $ApplicationVersion
		$objRange = $Doc.BookMarks.Item("HdrSec3_Version").Range
		$objRange.Text = "R01 B01"
		$objRange = $Doc.BookMarks.Item("Loc_Version").Range
		$objRange.Text = "R01-B01"
		$objRange = $Doc.BookMarks.Item("Loc_Date").Range
		$objRange.Text = Get-Date -f "dd/MM/yyyy"
		$objRange = $Doc.BookMarks.Item("Loc_Description").Range
		$objRange.Text = $ApplicationName + " " + $ApplicationVersion
		$objRange = $Doc.BookMarks.Item("Loc_Description2").Range
		$objRange.Text = $ApplicationName + " " + $ApplicationVersion
		$objRange = $Doc.BookMarks.Item("Loc_Author").Range
		$objRange.Text = $Packager
		$objRange = $Doc.BookMarks.Item("HdrSec4_Title").Range
		$objRange.Text = $Vendor + " " + $ApplicationName + " " + $ApplicationVersion
		$objRange = $Doc.BookMarks.Item("HdrSec4_Version").Range
		$objRange.Text = "R01 B01"
		$objRange = $Doc.BookMarks.Item("Sec1_Functionality").Range
		$objRange.Text = $Description
		$objRange = $Doc.BookMarks.Item("Sec1_Language").Range
		$objRange.Text = $Language
		$objRange = $Doc.BookMarks.Item("Sec1_Vendor").Range
		$objRange.Text = $Vendor
		$objRange = $Doc.BookMarks.Item("Sec1_Requestor").Range
		$objRange.Text = $Requestor
		$objRange = $Doc.BookMarks.Item("Sec1_RequestorEmail").Range
		$objRange.Text = $RequestorEmail
		$objRange = $Doc.BookMarks.Item("Sec1_RequestorTel").Range
		$objRange.Text = $RequestorTel
		$objRange = $Doc.BookMarks.Item("Sec2_SeqVersion").Range
		$objRange.Text = $SequencerVersion
		$objRange = $Doc.BookMarks.Item("Sec2_BrickName").Range
		$objRange.Text = $BrickName
		#$objRange = $Doc.BookMarks.Item("Sec2_AssetFolder").Range
		#$objRange.Text = $BrickName.Text
		$objRange = $Doc.BookMarks.Item("Sec2_DeployConfig").Range
		$objRange.Text = $BrickName
		$objRange = $Doc.BookMarks.Item("Sec2_UserConfig").Range
		$objRange.Text = $BrickName
		$objRange = $Doc.BookMarks.Item("Sec3_TargetOS").Range
		$objRange.Text = $Target
		$objRange = $Doc.BookMarks.Item("Sec3_AppName").Range
		$objRange.Text = $ApplicationName
		$objRange = $Doc.BookMarks.Item("Sec3_Vendor").Range
		$objRange.Text = $Vendor
		$objRange = $Doc.BookMarks.Item("Sec3_AppVersion").Range
		$objRange.Text = $ApplicationVersion
		$objRange = $Doc.BookMarks.Item("Sec3_InstallADGroup").Range
		$objRange.Text = $InstallADGroup
		$objRange = $Doc.BookMarks.Item("Sec3_InstallCommand").Range
		$objRange.Text = $InstallCommand
		$objRange = $Doc.BookMarks.Item("Sec3_UninstallADGroup").Range
		$objRange.Text = $UninstallADGroup
		$objRange = $Doc.BookMarks.Item("Sec3_UninstallCommand").Range
		$objRange.Text = $UninstallCommand			
		$Doc.SaveAs([ref]$buildlocalLocation, [ref]$wdFormatDocumentDefault)
    	$Doc.Close()	

}