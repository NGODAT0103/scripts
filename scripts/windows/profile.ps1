# profile.ps1 - loader, auto-sources all *.ps1 files under functions/
$FunctionsDir = Join-Path $PSScriptRoot "functions"

if (Test-Path $FunctionsDir) {
    Get-ChildItem -Path $FunctionsDir -Filter "*.ps1" -Recurse | Sort-Object FullName | ForEach-Object {
        try {
            . $_.FullName
        }
        catch {
            Write-Warning "Failed to load $($_.FullName): $_"
        }
    }
}
else {
    Write-Warning "Functions directory not found: $FunctionsDir"
}