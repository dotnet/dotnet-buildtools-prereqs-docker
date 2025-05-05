# escape=`

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:windowsservercore-ltsc2025-helix-amd64

# Install 7zip
ENV ZIP7_VERSION=2409

RUN curl -SL --output %TEMP%\7zip-x64.exe https://www.7-zip.org/a/7z%ZIP7_VERSION%-x64.exe `
    && mkdir C:\7z `
    && %TEMP%\7zip-x64.exe /S /D="C:\7z" `
    && setx PATH "%PATH%;C:\7z"

# Install arial font for chrome
COPY arial.ttf c:/windows/fonts

# Install git
ENV GIT_VERSION=2.34.1
ENV GIT_INSTALLER=MinGit-${GIT_VERSION}-64-bit.zip

RUN curl -SL --output %TEMP%\%GIT_INSTALLER% https://github.com/git-for-windows/git/releases/download/v%GIT_VERSION%.windows.1/%GIT_INSTALLER% `
    && mkdir C:\git `
    && tar -C C:\git -zxf %TEMP%\%GIT_INSTALLER% `
    && setx PATH "%PATH%;C:\git\cmd"

# fix certificates for python to be able to download emscripten files
RUN certutil -generateSSTFromWU roots.sst && certutil -addstore -f root roots.sst && del roots.sst

# Install Emscripten toolchain
ENV `
    EMSCRIPTEN_VERSION=3.1.34 `
    EMSCRIPTEN_PATH="C:\emscripten" `
    EMSDK_PATH="C:\emscripten\emsdk"

RUN mkdir %EMSCRIPTEN_PATH% `
    && cd %EMSCRIPTEN_PATH% `
    && git clone https://github.com/emscripten-core/emsdk.git %EMSDK_PATH% `
    && cd %EMSDK_PATH% `
    && git checkout %EMSCRIPTEN_VERSION% `
    && .\emsdk install %EMSCRIPTEN_VERSION%-upstream  `
    && .\emsdk activate %EMSCRIPTEN_VERSION%-upstream `
    && .\upstream\emscripten\embuilder.bat build MINIMAL

# Install latest 22.x Node JS
ENV NODE_RELEASE=22

RUN powershell -Command " `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        $json = Invoke-RestMethod -Uri 'https://nodejs.org/dist/index.json'; `
        $nodeVersionUrl = \"https://nodejs.org/dist/latest-v$env:NODE_RELEASE.x/SHASUMS256.txt\"; `
        $versionInfo = Invoke-WebRequest -Uri $nodeVersionUrl -UseBasicParsing; `
        $versionInfo.Content -match \"node-v$env:NODE_RELEASE\.\d+\.\d+-x64\.msi\" | Out-Null; `
        $latestVersion = $matches[0]; `
        $nodeUrl = \"https://nodejs.org/dist/latest-v$env:NODE_RELEASE.x/$latestVersion\"; `
        Write-Host \"Installing Node from $nodeUrl\"; `
        Invoke-WebRequest -Uri $nodeUrl -OutFile $env:TEMP\nodejs.msi; `
        Start-Process msiexec.exe -ArgumentList '/i', $env:TEMP\nodejs.msi, '/quiet', '/passive', '/qn', '/norestart' -NoNewWindow -Wait"

# install latest jsvu and v8 engine
RUN npm install jsvu -g `
    && npm exec -c "jsvu --os=win64 --engines=v8" `
    && setx PATH "%PATH%;%USERPROFILE%\.jsvu\bin" `
    && %USERPROFILE%\.jsvu\bin\v8 -e "console.log(version());quit();" `
    && npm uninstall jsvu -g
