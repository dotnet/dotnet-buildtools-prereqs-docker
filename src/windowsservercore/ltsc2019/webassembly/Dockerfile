FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

SHELL ["cmd", "/S", "/C"]

USER ContainerAdministrator

# Install python
RUN curl -SL --output %TEMP%\python.zip https://www.nuget.org/api/v2/package/python/3.9.5 \
    && md C:\Python C:\PythonTemp \
    && tar -zxf %TEMP%\python.zip -C C:\PythonTemp \
    && xcopy /s c:\PythonTemp\tools C:\Python \
    && copy C:\Python\python.exe C:\Python\python3.exe \
    && rd /s /q c:\PythonTemp \
    && del /q %TEMP%\python.zip \
    && setx /M PYTHONPATH "C:\Python\Lib;C:\Python\DLLs;" \
    && setx /M PATH "C:\Python;%PATH%"

# Install git
ENV GIT_VERSION=2.32.0
ENV GIT_INSTALLER=MinGit-${GIT_VERSION}-64-bit.zip

RUN curl -SL --output %TEMP%\%GIT_INSTALLER% https://github.com/git-for-windows/git/releases/download/v%GIT_VERSION%.windows.1/%GIT_INSTALLER% \
    && mkdir C:\git \
    && tar -C C:\git -zxf %TEMP%\%GIT_INSTALLER% \
    && setx PATH "%PATH%;C:\git\cmd"

# Install ninja generator
ENV NINJA_VERSION=1.10.2
RUN curl -SL --output %TEMP%\ninja-win.zip https://github.com/ninja-build/ninja/releases/download/v%NINJA_VERSION%/ninja-win.zip \
    && mkdir C:\ninja \
    && tar -C C:\ninja -zxf %TEMP%\ninja-win.zip \
    && setx PATH "%PATH%;C:\ninja"

# fix certificates for python to be able to download emscripten files
RUN certutil -generateSSTFromWU roots.sst && certutil -addstore -f root roots.sst && del roots.sst

# Install Emscripten toolchain
ENV EMSCRIPTEN_VERSION=2.0.23
ENV EMSCRIPTEN_PATH="C:\emscripten"
ENV EMSDK_PATH="C:\emscripten\emsdk"

RUN mkdir %EMSCRIPTEN_PATH% \
    && cd %EMSCRIPTEN_PATH% \
    && git clone https://github.com/emscripten-core/emsdk.git %EMSDK_PATH%
RUN cd %EMSDK_PATH% \
    && .\emsdk install %EMSCRIPTEN_VERSION%-upstream  \
    && .\emsdk activate %EMSCRIPTEN_VERSION%-upstream

# install Node JS
ENV NODE_VERSION 16.3.0

RUN curl -SL --output %TEMP%\nodejs.msi https://nodejs.org/dist/v%NODE_VERSION%/node-v%NODE_VERSION%-x64.msi
RUN msiexec /i %TEMP%\nodejs.msi /quiet /passive /qn /norestart

# install jsvu and engines
RUN npm install jsvu -g
RUN npm exec -c "jsvu --os=win64 --engines=v8,spidermonkey"
RUN setx PATH "%PATH%;%USERPROFILE%\.jsvu"

# Install cmake
ENV CMAKE_VERSION 3.20.3
RUN curl -SL --output %TEMP%\cmake-win.zip https://github.com/Kitware/CMake/releases/download/v%CMAKE_VERSION%/cmake-%CMAKE_VERSION%-windows-x86_64.zip \
    && mkdir C:\cmake \
    && tar -C C:\cmake -zxf %TEMP%\cmake-win.zip \
    && setx PATH "%PATH%;C:\cmake\cmake-%CMAKE_VERSION%-windows-x86_64\bin"

# Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe vs_buildtools.exe

# Visual Studio with .NET and C++ tools
RUN mkdir C:\BuildTools

RUN vs_buildtools.exe --quiet --wait --norestart --nocache \
    --installPath C:\BuildTools \
    --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools \
    --add Microsoft.VisualStudio.Workload.VCTools \
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 \
    --remove Microsoft.VisualStudio.Component.Windows81SDK \
    --add Microsoft.VisualStudio.Component.Windows10SDK.17763 \
|| IF "%ERRORLEVEL%"=="3010" EXIT 0

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
