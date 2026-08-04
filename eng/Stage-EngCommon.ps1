[CmdletBinding()]
param(
    [switch]$Clean
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path $PSScriptRoot -Parent
$source = Join-Path $PSScriptRoot 'common'
$dockerfiles = Get-ChildItem (Join-Path $repoRoot 'src') -Filter Dockerfile -File -Recurse |
    Where-Object {
        Select-String -LiteralPath $_.FullName -Pattern '^\s*COPY\s+eng/common/' -Quiet
    }

foreach ($dockerfile in $dockerfiles) {
    $engDirectory = Join-Path $dockerfile.Directory.FullName 'eng'
    $destination = Join-Path $engDirectory 'common'

    if (Test-Path -LiteralPath $destination) {
        Remove-Item -LiteralPath $destination -Recurse -Force
    }

    if (-not $Clean) {
        New-Item -Path $engDirectory -ItemType Directory -Force | Out-Null
        Copy-Item -LiteralPath $source -Destination $engDirectory -Recurse -Force
        Write-Host "Staged eng/common next to $($dockerfile.FullName)"
    }
}
