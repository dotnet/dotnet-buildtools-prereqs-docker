# escape=`
# Image for building the .NET
# Requirements: https://github.com/dotnet/runtime/blob/main/docs/workflow/requirements/windows-requirements.md

FROM mcr.microsoft.com/windows/servercore:ltsc2022

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install Chocolatey for package management
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Set-ExecutionPolicy Bypass -Scope Process -Force; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Git for Windows
# Enable long paths during installation and configure for system-wide use
RUN choco install git -y --params "'/GitAndUnixToolsOnPath /NoAutoCrlf /WindowsTerminal'" --version=2.45.2; `
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }; `
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('PATH', 'User'); `
    git config --system core.longpaths true; `
    git --version; `
    Remove-Item -Path C:\ProgramData\chocolatey\lib\git -Recurse -Force -ErrorAction SilentlyContinue

# Install CMake
RUN choco install cmake -y --installargs 'ADD_CMAKE_TO_PATH=System' --version=3.30.2; `
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }; `
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('PATH', 'User'); `
    cmake --version; `
    Remove-Item -Path C:\ProgramData\chocolatey\lib\cmake -Recurse -Force -ErrorAction SilentlyContinue

# Install Python
RUN choco install python -y --version=3.12.4; `
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }; `
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('PATH', 'User'); `
    python --version; `
    Remove-Item -Path C:\ProgramData\chocolatey\lib\python -Recurse -Force -ErrorAction SilentlyContinue

# Install Ninja build system
RUN choco install ninja -y; `
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }; `
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('PATH', 'User'); `
    ninja --version; `
    Remove-Item -Path C:\ProgramData\chocolatey\lib\ninja -Recurse -Force -ErrorAction SilentlyContinue

# Download, install, and clean up Visual Studio Build Tools in a single layer
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    New-Item -ItemType Directory -Path 'C:\TEMP' -Force | Out-Null; `
    Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_buildtools.exe' -OutFile 'C:\TEMP\vs_buildtools.exe'; `
    `
    Start-Process -Wait -FilePath C:\TEMP\vs_buildtools.exe -ArgumentList `
    '--quiet', `
    '--wait', `
    '--norestart', `
    '--nocache', `
    '--installPath', 'C:\BuildTools', `
    '--includeRecommended', `
    '--add', 'Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools', `
    '--add', 'Microsoft.VisualStudio.Workload.VCTools', `
    '--add', 'Microsoft.VisualStudio.Workload.NativeDesktop', `
    '--add', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64', `
    '--add', 'Microsoft.VisualStudio.Component.VC.Tools.ARM64', `
    '--add', 'Microsoft.VisualStudio.Component.VC.Tools.ARM64EC', `
    '--add', 'Microsoft.VisualStudio.Component.VC.CLI.Support', `
    '--add', 'Microsoft.VisualStudio.Component.VC.CMake.Project', `
    '--add', 'Microsoft.VisualStudio.Component.Windows10SDK.20348'; `
    `
    # VS installer returns 3010 for success with reboot required, which is acceptable in Docker
    if (($LASTEXITCODE -ne 0) -and ($LASTEXITCODE -ne 3010)) { `
        exit $LASTEXITCODE; `
    }; `
    `
    # Clean up installer and temp files in the same layer
    Remove-Item -Path C:\TEMP -Recurse -Force -ErrorAction SilentlyContinue; `
    Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue; `
    Remove-Item -Path C:\ProgramData\chocolatey\cache -Recurse -Force -ErrorAction SilentlyContinue

# Enable Windows long path support via registry
RUN New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' `
    -Name 'LongPathsEnabled' -Value 1 -PropertyType DWORD -Force

# Set default shell back to cmd for compatibility
SHELL ["cmd", "/S", "/C"]
