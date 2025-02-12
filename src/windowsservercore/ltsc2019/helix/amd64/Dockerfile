# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Install latest stable version of Python
RUN powershell -Command "`
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        $apiUrl = 'https://api.nuget.org/v3-flatcontainer/python/index.json'; `
        $response = Invoke-RestMethod -Uri $apiUrl; `
        $versions = $response.versions | Where-Object { $_ -notmatch '-' } | Sort-Object { [version]$_ } -Descending; `
        $latestVersion = $versions[0]; `
        echo \"Downloading Python $latestVersion\"; `
        Invoke-WebRequest -Uri https://www.nuget.org/api/v2/package/python/$latestVersion -OutFile $env:TEMP\python.zip; `
        md C:\Python; `
        md C:\PythonTemp; `
        tar -zxf  $env:TEMP\python.zip -C C:\PythonTemp; `
        xcopy /s c:\PythonTemp\tools C:\Python; `
        Remove-Item -Recurse -Force C:\PythonTemp; `
        Remove-Item -Force $env:TEMP\python.zip;"

RUN setx /M PATH "%PATH%;C:\Python;C:\python\scripts" && `
    setx /M PYTHONPATH "C:\Python\Lib;C:\Python\DLLs;" && `
    setx /M VIRTUAL_ENV "C:\Python-env"

RUN python -m pip install --upgrade pip && `
    python -m pip install venv && `
    python -m venv %VIRTUAL_ENV% && `
    powershell -Command `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'dotnet.exe' -Force -ErrorAction SilentlyContinue ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpType -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 'C:\cores' -Name DumpFolder -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpCount -Force ; `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'corerun.exe' -Force -ErrorAction SilentlyContinue ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpType -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 'C:\cores' -Name DumpFolder -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpCount -Force

WORKDIR C:\Work
