# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS installer

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN $apiUrl = 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest'; `
    $response = Invoke-RestMethod -Uri $apiUrl; `
    $url = $response.assets | Where-Object { $_.browser_download_url -match 'win-x64.zip' } | Select-Object -ExpandProperty browser_download_url; `
    Invoke-WebRequest -Uri $url -OutFile C:\powershell.zip; `
    Expand-Archive -Path C:\powershell.zip -DestinationPath C:\powershell; `
    Remove-Item -Path C:\powershell.zip

# Download latest stable version of Python
RUN $apiUrl = 'https://api.nuget.org/v3-flatcontainer/python/index.json'; `
    $response = Invoke-RestMethod -Uri $apiUrl; `
    $versions = $response.versions | Where-Object { $_ -notmatch '-' } | Sort-Object { [version]$_ } -Descending; `
    $latestVersion = $versions[0]; `
    Invoke-WebRequest -Uri https://www.nuget.org/api/v2/package/python/$latestVersion -OutFile $env:TEMP\python.zip; `
    md C:\PythonTemp; `
    tar -zxf  $env:TEMP\python.zip -C C:\PythonTemp;


FROM mcr.microsoft.com/windows/nanoserver:1809

USER ContainerAdministrator

COPY --from=installer [ "C:\\powershell\\", "C:\\Program Files\\PowerShell\\" ]

COPY --from=installer [ "C:\\PythonTemp\\tools", "C:\\Python\\" ]

ENV PATH="$PATH;C:\Program Files\PowerShell\;C:\Python;C:\python\scripts" `
    PYTHONPATH="C:\Python\Lib;C:\Python\DLLs;" `
    VIRTUAL_ENV="C:\Python-env"

RUN python -m pip install --upgrade pip && `
    python -m pip install virtualenv && `
    python -m venv %VIRTUAL_ENV% && `
    pwsh -Command `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'dotnet.exe' -Force -ErrorAction SilentlyContinue ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpType -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 'C:\cores' -Name DumpFolder -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpCount -Force ; `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'corerun.exe' -Force -ErrorAction SilentlyContinue ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpType -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 'C:\cores' -Name DumpFolder -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpCount -Force

WORKDIR C:\Work
