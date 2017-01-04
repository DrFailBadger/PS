Set-ExecutionPolicy Unrestricted -force
Import-Module appvclient
set-AppvClientConfiguration -EnablePackageScripts 1
Add-AppvClientPackage -Path C:\Thaler-3103-AV5-ZZZ-63-R01-R01\Thaler-3103-AV5-ZZZ-63-R01-R01.appv | Publish-AppvClientPackage -Global
Get-AppvClientPackage | Unpublish-AppvClientPackage -global | Remove-AppvClientPackage 


Get-AppvClientPackage

        <Path>SciptRunner.exe</Path>
        <Arguments>
			-appvscript cmd.exe /c COPY "[{ProgramFilesX64}]\Thaler 3.1.0.3\TLR3ZZZ.300\env.ini" "[{ProgramFilesX64}]\Thaler 3.1.0.3\env.ini" -appvscriptrunnerparameters -wait
		</Arguments>

#[{ProgramFilesX64}]\Thaler 3.1.0.3\TLR3ZZZ.300\ENV.ini


&  'C:\Program Files\Microsoft Application Virtualization\Client\ScriptRunner.exe' -?
$scriptrunner = 'C:\Program Files\Microsoft Application Virtualization\Client\ScriptRunner.exe'
& $scriptrunner -appvscript "C:\windows\system32\cmd.exe" /k COPY  "[{AppVPackageRoot}]\VFS\ProgramFilesX64\Thaler 3.1.0.3\TLR3ZZZ.300\Env.ini" "C:\Packages\ENV.ini" -appvscriptrunnerparameters -wait -timeout=120 