param(
    [string]$AppPath = ".\maestro.exe",
    [string]$ConfigPath = ".\maestro.settings.json"
)

$ErrorActionPreference = "Stop"

Write-Host "== Maestro smoke test =="
Write-Host "app: $AppPath"
Write-Host "config: $ConfigPath"

& $AppPath --version
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& $AppPath --doctor --config $ConfigPath
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "smoke test passed"
