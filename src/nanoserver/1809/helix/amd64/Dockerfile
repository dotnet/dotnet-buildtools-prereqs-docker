# escape=`
FROM mcr.microsoft.com/powershell:6.2.0-nanoserver-1809

SHELL ["cmd", "/S", "/C"]
USER ContainerAdministrator
ENTRYPOINT C:\Windows\System32\cmd.exe

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

