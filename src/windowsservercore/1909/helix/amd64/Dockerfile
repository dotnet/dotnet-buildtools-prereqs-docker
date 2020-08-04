# escape=`
FROM mcr.microsoft.com/windows/servercore:1909

SHELL ["cmd", "/S", "/C"]
USER ContainerAdministrator

RUN curl -SL --output %TEMP%\python.zip https://www.nuget.org/api/v2/package/python/3.7.3 `
    && md C:\Python C:\PythonTemp `
    && tar -zxf %TEMP%\python.zip -C C:\PythonTemp `
    && xcopy /s c:\PythonTemp\tools C:\Python `
    && rd /s /q c:\PythonTemp `
    && del /q %TEMP%\python.zip `
    && setx /M PYTHONPATH "C:\Python\Lib;C:\Python\DLLs;"

RUN md c:\\helixtmp && pushd c:\\helixtmp &&`
    C:\Python\python.exe -m pip install --upgrade pip==20.2 --no-warn-script-location && `
    C:\Python\python.exe -m pip install virtualenv==16.6.0 --no-warn-script-location && `
    C:\Python\python.exe -m pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && `
    for %f in (.\helix_scripts-*-py3-none-any.whl) do (C:\Python\python.exe -m pip install %f  --no-warn-script-location) && `
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

