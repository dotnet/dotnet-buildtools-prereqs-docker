# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS installer

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN $apiUrl = 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest'; `
    $response = Invoke-RestMethod -Uri $apiUrl; `
    $url = $response.assets | Where-Object { $_.browser_download_url -match 'win-x64.zip' } | Select-Object -ExpandProperty browser_download_url; `
    Invoke-WebRequest -Uri $url -OutFile C:\powershell.zip; `
    Expand-Archive -Path C:\powershell.zip -DestinationPath C:\powershell; `
    Remove-Item -Path C:\powershell.zip


FROM mcr.microsoft.com/windows/nanoserver:1809

USER ContainerAdministrator
ENTRYPOINT C:\Windows\System32\cmd.exe

COPY --from=installer [ "C:\\powershell\\", "C:\\Program Files\\PowerShell\\" ]

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install latest stable version of Python
RUN $apiUrl = "https://api.nuget.org/v3-flatcontainer/python/index.json"; `
    $response = Invoke-RestMethod -Uri $apiUrl; `
    $versions = $response.versions | Where-Object { $_ -notmatch '-' } | Sort-Object { [version]$_ } -Descending; `
    $latestVersion = $versions[0]; `
    curl -SL --output $env:TEMP\python.zip https://www.nuget.org/api/v2/package/python/$latestVersion; `
    md C:\Python; `
    md C:\PythonTemp; `
    tar -zxf  $env:TEMP\python.zip -C C:\PythonTemp; `
    xcopy /s c:\PythonTemp\tools C:\Python; `
    Remove-Item -Recurse -Force C:\PythonTemp; `
    Remove-Item -Force $env:TEMP\python.zip; `
    setx /M PYTHONPATH "C:\Python\Lib;C:\Python\DLLs;"

SHELL ["cmd", "/S", "/C"]

ENV PATH="$PATH;C:\Program Files\PowerShell\;C:\Python;C:\python\scripts"

RUN md c:\\helixtmp && pushd c:\\helixtmp && `
    python -m pip install --upgrade pip && `
    python -m pip install virtualenv && `
    popd && rd /s /q c:\\helixtmp && `
    pwsh -Command `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'dotnet.exe' -Force -ErrorAction SilentlyContinue ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpType -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 'C:\cores' -Name DumpFolder -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpCount -Force ; `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'corerun.exe' -Force -ErrorAction SilentlyContinue ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpType -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 'C:\cores' -Name DumpFolder -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpCount -Force

WORKDIR C:\\Work
