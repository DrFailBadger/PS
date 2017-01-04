 $sz = "$env rogramFiles\7-Zip\7z.exe" 
& $sz e "$archive" -o"$SaveToLocation\$($instllationfolder.BaseName)"  -p"$encryptionkey"  
