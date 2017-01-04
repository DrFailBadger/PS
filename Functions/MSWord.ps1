Function OpenWordDoc($Filename)

{

$Word=NEW-Object –comobject Word.Application

Return $Word.documents.open($Filename)

}


Function SearchAWord($Document,$findtext,$replacewithtext)

{ 

  $FindReplace=$Document.ActiveWindow.Selection.Find

  $matchCase = $false;

  $matchWholeWord = $true;

  $matchWildCards = $false;

  $matchSoundsLike = $false;

  $matchAllWordForms = $false;

  $forward = $true;

  $format = $false;

  $matchKashida = $false;

  $matchDiacritics = $false;

  $matchAlefHamza = $false;

  $matchControl = $false;

  $read_only = $false;

  $visible = $true;

  $replace = 2;

  $wrap = 1;

  $FindReplace.Execute($findText, $matchCase, $matchWholeWord, $matchWildCards, $matchSoundsLike, $matchAllWordForms, $forward, $wrap, $format, $replaceWithText, $replace, $matchKashida ,$matchDiacritics, $matchAlefHamza, $matchControl)

}

Function SaveAsWordDoc($Document,$FileName)

{

$Document.Saveas([REF]$Filename)

$Document.close()

}


$AppVTemplate = OpenWordDoc -Filename "C:\git\Dave\ForDave\Thaler Template.docx"

SearchAWord -Document $AppVTemplate -findtext 'ZZZ' -replacewithtext 'BBB'

$savename = "new doc name.doc"

SaveAsWordDoc -Document $AppVTemplate -FileName $savename


