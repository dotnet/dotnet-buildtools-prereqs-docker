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

SHELL ["cmd", "/S", "/C"]
USER ContainerAdministrator
ENTRYPOINT C:\Windows\System32\cmd.exe

COPY --from=installer [ "C:\\powershell\\", "C:\\Program Files\\PowerShell\\" ]

RUN curl -SL --output %TEMP%\python.zip https://www.nuget.org/api/v2/package/python/3.7.3 `
    && md C:\Python C:\PythonTemp `
    && tar -zxf %TEMP%\python.zip -C C:\PythonTemp `
    && xcopy /s c:\PythonTemp\tools C:\Python `
    && rd /s /q c:\PythonTemp `
    && del /q %TEMP%\python.zip `
    && setx /M PYTHONPATH "C:\Python\Lib;C:\Python\DLLs;"

ENV PATH="$PATH;C:\Program Files\PowerShell\;C:\Python;C:\python\scripts"

RUN md c:\\helixtmp && pushd c:\\helixtmp &&`
    python -m pip install --upgrade pip==20.2 && `
    python -m pip install virtualenv==16.6.0 && `
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && `
    for %f in (.\helix_scripts-*-py3-none-any.whl) do (pip install %f) && `
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

