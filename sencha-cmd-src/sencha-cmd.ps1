$downloadurl = "http://cdn.sencha.com/cmd/7.2.0.84/jre/SenchaCmd-7.2.0.84-windows-64bit.zip"
$path = split-path $MyInvocation.MyCommand.Path

Write-Output "Command path: $path"
Write-Output "Download SenchaCmd: $downloadurl"
$start_time = Get-Date
$output = $path + "\SenchaCmd.zip"

(New-Object System.Net.WebClient).DownloadFile($downloadurl, $output)

Write-Output "Time taken (Download): $((Get-Date).Subtract($start_time).Seconds) second(s)"

Write-Output "Extract SenchaCmd"
$start_time = Get-Date

Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory($output, $path)

Write-Output "Time taken (Unzip): $((Get-Date).Subtract($start_time).Seconds) second(s)"

Write-Output "Start installation of SenchaCmd"
$start_time = Get-Date
Start-Process -Wait -PassThru .\SenchaCmd-7.2.0.84-windows-64bit.exe -ArgumentList "-q -dir /sencha-cmd"

Write-Output "Time taken (Installation): $((Get-Date).Subtract($start_time).Seconds) second(s)"

$javaOptions = "-Xms128m -Xmx2048m"
[Environment]::SetEnvironmentVariable(
    "_JAVA_OPTIONS",
    $javaOptions,
    [EnvironmentVariableTarget]::User)
	
$env:Path += ";" + $path + "\sencha-cmd;"
[Environment]::SetEnvironmentVariable(
    "Path",
    $env:Path,
    [EnvironmentVariableTarget]::User)
	
Remove-Item $output