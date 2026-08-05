[CmdletBinding()]
param(
    [switch]$Clean
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-FolderStructure {
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [ValidateRange(0, 10)]
        [int]$Depth = 2
    )

    $resolvedPath = (Resolve-Path -LiteralPath $Path).Path
    Write-Host "Folder structure for: $resolvedPath"

    Get-ChildItem -LiteralPath $resolvedPath -Recurse -Depth $Depth |
        ForEach-Object {
            $relativePath = [System.IO.Path]::GetRelativePath($resolvedPath, $_.FullName)
            $suffix = if ($_.PSIsContainer) { [System.IO.Path]::DirectorySeparatorChar } else { '' }
            Write-Host "  $relativePath$suffix"
        }
}

$repoRoot = Split-Path $PSScriptRoot -Parent
$source = Join-Path $PSScriptRoot 'common'
$dockerfiles = Get-ChildItem (Join-Path $repoRoot 'src') -Filter Dockerfile -File -Recurse |
    Where-Object {
        Select-String -LiteralPath $_.FullName -Pattern '^\s*COPY\s+eng/common/' -Quiet
    }

Write-Host "RepoRoot: $repoRoot"
Write-FolderStructure -Path $repoRoot

foreach ($dockerfile in $dockerfiles) {
    Write-Host "Processing Dockerfile: $($dockerfile.FullName)"
    $engDirectory = Join-Path $dockerfile.Directory.FullName 'eng'
    $destination = Join-Path $engDirectory 'common'

    if (Test-Path -LiteralPath $destination) {
        Remove-Item -LiteralPath $destination -Recurse -Force
    }

    if (-not $Clean) {
        Write-Host " - Destination for eng/common: $destination"
        New-Item -Path $engDirectory -ItemType Directory -Force | Out-Null
        Copy-Item -LiteralPath $source -Destination $engDirectory -Recurse -Force
        Write-Host " - Destination folder structure:"
        Write-FolderStructure -Path $destination
        Write-Host ""
    }
}
