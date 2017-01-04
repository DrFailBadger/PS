[xml] $xdoc =  get-content "C:\uam\_MassConversion\books.xml"
$xdoc
$xdoc.SelectNodes(“//author”)

$xdoc.SelectSingleNode(“//book[2]”)

$xdoc.SelectNodes("//author") | select -Unique 

$xdoc.SelectNodes(“//author”) |  % { $_.FirstChild.Value } |  select  -Unique

$xdoc.SelectNodes(“//author”) |  % { $_.InnerText } |  select  -Unique

$xdoc |  Select-Xml “//author” |  % { $_.Node.InnerText } |  select  -Unique

$xdoc.SelectSingleNode("//book[6]/author").InnerText = 'jones'
$xdoc.catalog.book[5].author = 'smith' 

[xml] $xdoc = get-content ".\sample-new.xml"
$xdoc.catalog.book[5].author = 'audubon, j.'
$xdoc.catalog.book[5].title = 'The Birds of America'
$xdoc.Save(".\sample-new.xml") 

$book = $xdoc.catalog.book[0].Clone()
$book.author = 'Dickens, Charles'
$book.title = 'The Old Curiousity Shop'
# etc. with remaining properties. . . 
[Void] $xdoc.catalog.AppendChild($book)




