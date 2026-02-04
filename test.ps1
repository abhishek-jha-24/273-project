$ErrorActionPreference = "SilentlyContinue"

# Test Service A health
Write-Host "Testing Service A /health endpoint:"
$response = Invoke-WebRequest -Uri "http://127.0.0.1:8080/health" -UseBasicParsing
Write-Host $response.Content
Write-Host ""

# Test Service B calling Service A
Write-Host "Testing Service B /call-echo endpoint:"
$response = Invoke-WebRequest -Uri "http://127.0.0.1:8081/call-echo?msg=hello" -UseBasicParsing
Write-Host $response.Content
Write-Host ""

# Stop Service A to test failure scenario
Write-Host "Stopping Service A to test failure handling..."
Get-Process python | Where-Object { $_.CommandLine -like "*service-a*" } | Stop-Process -Force
Start-Sleep -Seconds 1

# Test Service B when Service A is down
Write-Host "Testing Service B /call-echo when Service A is down:"
$response = Invoke-WebRequest -Uri "http://127.0.0.1:8081/call-echo?msg=hello" -UseBasicParsing
Write-Host $response.Content
Write-Host ""

Write-Host "Test complete!"
