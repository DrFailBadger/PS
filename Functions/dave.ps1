Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'dave.designer.ps1')
$Form1.ShowDialog()