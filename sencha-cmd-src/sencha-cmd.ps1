$version = Get-VstsInput -Name version -Require;
$javaoptions = Get-VstsInput -Name javaoptions;

Write-Output $version
Write-Output $javaoptions

$downloaduri = "http://cdn.sencha.com/cmd/" + $version + "/jre/SenchaCmd-" + $version + "-windows-64bit.zip"
$installerexe = ".\SenchaCmd-" + $version + "-windows-64bit.exe"

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
Start-Process -Wait -PassThru $installerexe -ArgumentList "-q -dir /sencha-cmd"

Write-Output "Time taken (Installation): $((Get-Date).Subtract($start_time).Seconds) second(s)"
if($javaoptions -ne ""){
	Write-Host "##vso[task.setvariable variable=_JAVA_OPTIONS;]$javaoptions";
}

$senchadir = $currentpath + "\sencha-cmd;"
Write-Host "##vso[task.setvariable variable=PATH;]${env:PATH};$senchadir";

Remove-Item $output