# Auto-elevate to admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}

# Fix DNS — set to Google DNS to unblock Netlify
Write-Host "Changing DNS to Google (8.8.8.8)..." -ForegroundColor Cyan
$adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
foreach ($adapter in $adapters) {
    Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses ("8.8.8.8","8.8.4.4")
    Write-Host "  DNS set for: $($adapter.Name)" -ForegroundColor Green
}
ipconfig /flushdns | Out-Null
Write-Host ""
Write-Host "SUCCESS! DNS is now Google (8.8.8.8 / 8.8.4.4)" -ForegroundColor Green
Write-Host "Try opening: https://orthodontic-analysis.netlify.app" -ForegroundColor Yellow
Read-Host "Press Enter to close"
