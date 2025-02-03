# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019

USER ContainerAdministrator

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

RUN md c:\\helixtmp && pushd c:\\helixtmp &&`
    C:\Python\python.exe -m pip install --upgrade pip --no-warn-script-location && `
    C:\Python\python.exe -m pip install virtualenv --no-warn-script-location && `
    popd && rd /s /q c:\\helixtmp && `
    powershell -Command `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'dotnet.exe' -Force -ErrorAction SilentlyContinue ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpType -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 'C:\cores' -Name DumpFolder -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpCount -Force ; `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'corerun.exe' -Force -ErrorAction SilentlyContinue ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpType -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 'C:\cores' -Name DumpFolder -Force ; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpCount -Force && `
   setx /M PATH "%PATH%;C:\Python;C:\python\scripts"    

WORKDIR C:\\Work
