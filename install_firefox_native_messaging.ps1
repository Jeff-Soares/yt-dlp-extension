$currentUser = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$isAdmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    $scriptPath = $MyInvocation.MyCommand.Path
    $scriptArguments = $MyInvocation.MyCommand.UnboundArguments
    $workingDirectory = Get-Location | Select-Object -ExpandProperty Path

    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList @(
        "-ExecutionPolicy",
        "Bypass",
        "-Command",
        "Set-Location '$workingDirectory'; & '$scriptPath' $scriptArguments"
    )
    Exit
}

$destinationPath = "$env:APPDATA\Mozilla\NativeMessagingHosts"

if (-not (Test-Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
}

Copy-Item -Path "script.bat" -Destination $destinationPath -Force
Copy-Item -Path "main.py" -Destination $destinationPath -Force
Copy-Item -Path "mozilla\com.jx.yt_dlp.json" -Destination $destinationPath -Force
Write-Host "Files copied to $destinationPath"

$jsonFilePath = "$destinationPath\com.jx.yt_dlp.json"
$registryPath = "HKLM:\Software\Mozilla\NativeMessagingHosts\com.jx.yt_dlp"

if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

Set-ItemProperty -Path $registryPath -Name "(Default)" -Value $jsonFilePath
Write-Host "Added to windows registry. ($registryPath)"

Write-Host "Press any key to continue..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
