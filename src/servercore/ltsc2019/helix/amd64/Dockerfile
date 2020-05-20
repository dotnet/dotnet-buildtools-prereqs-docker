# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019

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

RUN C:\Python\python.exe -m pip install --upgrade pip && `
    C:\Python\python.exe -m pip install virtualenv==16.5.0 --no-warn-script-location && `
    C:\Python\python.exe -m pip install helix-scripts --no-warn-script-location --extra-index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && `
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

