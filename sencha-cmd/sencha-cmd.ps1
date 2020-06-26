$downloadurl = "http://cdn.sencha.com/cmd/7.2.0.84/jre/SenchaCmd-7.2.0.84-windows-64bit.zip"

$path = split-path $MyInvocation.MyCommand.Path

Write-Output "Download SenchaCmd"
$output = $path + "\SenchaCmd.zip"
$start_time = Get-Date

(New-Object System.Net.WebClient).DownloadFile($downloadurl, $output)

Write-Output "Time taken (Download): $((Get-Date).Subtract($start_time).Seconds) second(s)"

Write-Output "Extract SenchaCmd"
$destination = $path + "\sencha-cmd"
$start_time = Get-Date

Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory($output, $destination)

Write-Output "Time taken (Unzip): $((Get-Date).Subtract($start_time).Seconds) second(s)"

Write-Output "Start installation of SenchaCmd"
$start_time = Get-Date
Start-Process -Wait -PassThru .\SenchaCmd-7.2.0.84-windows-64bit.exe -ArgumentList "-q -dir /"

Write-Output "Time taken (Installation): $((Get-Date).Subtract($start_time).Seconds) second(s)"

$javaOptions = "-Xms128m -Xmx2048m"
$env:_JAVA_OPTIONS = $javaOptions
Write-Host("##vso[task.setvariable variable=_JAVA_OPTIONS;]$javaOptions")

$env:Path += $destination
