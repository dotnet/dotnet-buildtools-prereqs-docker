FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019

SHELL ["cmd", "/S", "/C"]

USER ContainerAdministrator

# Install Visual Studio .NET and C++ tools
RUN curl -SL --output vs_buildtools.exe https://aka.ms/vs/16/release/vs_buildtools.exe \
    && (start /w vs_buildtools.exe --quiet --wait --norestart --nocache \
    --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\BuildTools" \
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 \
    --remove Microsoft.VisualStudio.Component.Windows81SDK \
    --add Microsoft.VisualStudio.Component.Windows10SDK.17763 \
    || IF "%ERRORLEVEL%"=="3010" EXIT 0) \
    && del /q vs_buildtools.exe \
    && del /q /f /s %TEMP%\* \
    && (for /D %i in ("%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\*") do rmdir /S /Q "%i") \
    && (for %i in ("%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\*") do if not "%~nxi" == "vswhere.exe" del "%~i") \
    && rmdir /S /Q "%ProgramData%\Package Cache"

# Install python
ENV PYTHON_VERSION=3.9.5

RUN curl -SL --output %TEMP%\python.zip https://www.nuget.org/api/v2/package/python/%PYTHON_VERSION% \
    && md C:\PythonTemp \
    && tar -C C:\PythonTemp -zxf %TEMP%\python.zip tools \
    && move C:\PythonTemp\tools C:\Python \
    && rd /q C:\PythonTemp \
    && copy C:\Python\python.exe C:\Python\python3.exe \
    && del /q %TEMP%\python.zip \
    && setx /M PYTHONPATH "C:\Python\Lib;C:\Python\DLLs;" \
    && setx /M PATH "C:\Python;%PATH%"

# Install git
ENV GIT_VERSION=2.32.0
ENV GIT_INSTALLER=MinGit-${GIT_VERSION}-64-bit.zip

RUN curl -SL --output %TEMP%\%GIT_INSTALLER% https://github.com/git-for-windows/git/releases/download/v%GIT_VERSION%.windows.1/%GIT_INSTALLER% \
    && mkdir C:\git \
    && tar -C C:\git -zxf %TEMP%\%GIT_INSTALLER% \
    && setx /M PATH "%PATH%;C:\git\cmd" \
    && del /q %TEMP%\%GIT_INSTALLER%

# Install ninja generator
ENV NINJA_VERSION=1.10.2
RUN curl -SL --output %TEMP%\ninja-win.zip https://github.com/ninja-build/ninja/releases/download/v%NINJA_VERSION%/ninja-win.zip \
    && mkdir C:\ninja \
    && tar -C C:\ninja -zxf %TEMP%\ninja-win.zip \
    && setx /M PATH "%PATH%;C:\ninja" \
    && del /q %TEMP%\ninja-win.zip

# fix certificates for python to be able to download emscripten files
RUN certutil -generateSSTFromWU roots.sst && certutil -addstore -f root roots.sst && del roots.sst

# Install Emscripten toolchain
ENV EMSCRIPTEN_VERSION=2.0.21
ENV EMSCRIPTEN_PATH="C:\emscripten"
ENV EMSDK_PATH="C:\emscripten\emsdk"

RUN mkdir %EMSCRIPTEN_PATH% \
    && cd %EMSCRIPTEN_PATH% \
    && git clone https://github.com/emscripten-core/emsdk.git %EMSDK_PATH% \
    && cd %EMSDK_PATH% \
    && .\emsdk install %EMSCRIPTEN_VERSION%-upstream  \
    && .\emsdk activate %EMSCRIPTEN_VERSION%-upstream

# install Node JS
ENV NODE_VERSION 16.3.0
RUN curl -SL --output %TEMP%\nodejs.msi https://nodejs.org/dist/v%NODE_VERSION%/node-v%NODE_VERSION%-x64.msi \
    && msiexec /i %TEMP%\nodejs.msi /quiet /passive /qn /norestart \
    && del /q %TEMP%\nodejs.msi

# install jsvu and engines
RUN npm install jsvu -g \
    && npm exec -c "jsvu --os=win64 --engines=v8,spidermonkey" \
    && setx /M PATH "%PATH%;%USERPROFILE%\.jsvu"

# Install cmake
ENV CMAKE_VERSION 3.20.3
RUN curl -SL --output %TEMP%\cmake-win.zip https://github.com/Kitware/CMake/releases/download/v%CMAKE_VERSION%/cmake-%CMAKE_VERSION%-windows-x86_64.zip \
    && mkdir C:\cmake \
    && tar -C C:\cmake -zxf %TEMP%\cmake-win.zip \
    && setx /M PATH "%PATH%;C:\cmake\cmake-%CMAKE_VERSION%-windows-x86_64\bin" \
    && del /q %TEMP%\cmake-win.zip
