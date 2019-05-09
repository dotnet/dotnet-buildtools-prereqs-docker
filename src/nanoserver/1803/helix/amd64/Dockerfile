FROM mcr.microsoft.com/powershell:6.2.0-nanoserver-1803

SHELL ["cmd", "/S", "/C"]
USER ContainerAdministrator
ENTRYPOINT C:\Windows\System32\cmd.exe

RUN curl -SL --output %TEMP%\python.zip https://www.nuget.org/api/v2/package/python/3.7.3 \
    && md C:\Python C:\PythonTemp \
    && tar -zxf %TEMP%\python.zip -C C:\PythonTemp \
    && xcopy /s c:\PythonTemp\tools C:\Python \
    && rd /s /q c:\PythonTemp \
    && del /q %TEMP%\python.zip

RUN setx /M PATH "%PATH%;C:\Program Files\PowerShell\;C:\Python;C:\python\scripts" \
    && setx /M PYTHONPATH "C:\Python\Lib;C:\Python\DLLs;"

RUN python -m pip install --upgrade pip \
    && python -m pip install applicationinsights==0.11.8 \
                             certifi==2019.3.9 \
                             docker==3.7.2 \
                             ndg-httpsclient==0.5.1 \
                             psutil==5.6.1 \
                             pyasn1==0.4.5 \
                             pyopenssl==19.0.0 \
                             requests==2.21.0 \
                             six==1.12.0 \
                             virtualenv==16.5.0

WORKDIR C:\\Work

