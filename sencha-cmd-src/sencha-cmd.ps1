$downloaduri = Get-VstsInput -Name downloaduri -Require;
$currentpath = split-path $MyInvocation.MyCommand.Path
Write-Output $currentpath

Write-Output "Command path: $currentpath"
Write-Output "Download SenchaCmd: $downloaduri"
$start_time = Get-Date
$output = $currentpath + "\SenchaCmd.zip"

(New-Object System.Net.WebClient).DownloadFile($downloaduri, $output)

Write-Output "Time taken (Download): $((Get-Date).Subtract($start_time).Seconds) second(s)"

Write-Output "Extract SenchaCmd"
$start_time = Get-Date

Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory($output, $currentpath)

Write-Output "Time taken (Unzip): $((Get-Date).Subtract($start_time).Seconds) second(s)"

Write-Output "Start installation of SenchaCmd"
$start_time = Get-Date
Start-Process -Wait -PassThru .\SenchaCmd-7.2.0.84-windows-64bit.exe -ArgumentList "-q -dir /sencha-cmd"

Write-Output "Time taken (Installation): $((Get-Date).Subtract($start_time).Seconds) second(s)"

Write-Host "##vso[task.setvariable variable=_JAVA_OPTIONS;]-Xms128m -Xmx2048m";

$senchadir = $currentpath + "\sencha-cmd;"
Write-Host "##vso[task.setvariable variable=PATH;]${env:PATH};$senchadir";

Remove-Item $output