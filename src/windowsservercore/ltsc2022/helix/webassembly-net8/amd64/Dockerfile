# escape=`

ARG ZIP7_VERSION=2501
ARG GIT_VERSION=2.34.1
ARG EMSCRIPTEN_VERSION=3.1.34
ARG NODE_RELEASE=22

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:windowsservercore-ltsc2022-helix-amd64 as installer

ARG ZIP7_VERSION
ARG GIT_VERSION
ARG EMSCRIPTEN_VERSION
ARG NODE_RELEASE

# Install 7zip
ENV ZIP7_VERSION=${ZIP7_VERSION}

RUN curl -SL --output %TEMP%\7zip-x64.exe https://www.7-zip.org/a/7z%ZIP7_VERSION%-x64.exe `
    && mkdir C:\7z `
    && %TEMP%\7zip-x64.exe /S /D="C:\7z" `
    && setx PATH "%PATH%;C:\7z"

# Install arial font for chrome
COPY arial.ttf c:/windows/fonts

# Install git
ENV GIT_VERSION=${GIT_VERSION}
ENV GIT_INSTALLER=MinGit-${GIT_VERSION}-64-bit.zip

RUN curl -SL --output %TEMP%\%GIT_INSTALLER% https://github.com/git-for-windows/git/releases/download/v%GIT_VERSION%.windows.1/%GIT_INSTALLER% `
    && mkdir C:\git `
    && tar -C C:\git -zxf %TEMP%\%GIT_INSTALLER% `
    && setx PATH "%PATH%;C:\git\cmd"

# fix certificates for python to be able to download emscripten files
RUN certutil -generateSSTFromWU roots.sst && certutil -addstore -f root roots.sst && del roots.sst

# Install Emscripten toolchain
ENV `
    EMSCRIPTEN_VERSION=${EMSCRIPTEN_VERSION} `
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
ENV NODE_RELEASE=${NODE_RELEASE}

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

ARG NPM_TOKEN

# hadolint ignore=SC1072
RUN if defined NPM_TOKEN ( `
        npm config set registry https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public-npm/npm/registry/ `
        && npm config set "//pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public-npm/npm/registry/:_authToken" %NPM_TOKEN% `
    ) else (echo Skipping npm config - using default registry)

# install latest jsvu and v8 engine
RUN npm install jsvu -g `
    && npm exec -c "jsvu --os=win64 --engines=v8" `
    && setx PATH "%PATH%;%USERPROFILE%\.jsvu\bin" `
    && %USERPROFILE%\.jsvu\bin\v8 -e "console.log(version());quit();" `
    && npm uninstall jsvu -g

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:windowsservercore-ltsc2022-helix-amd64

ARG ZIP7_VERSION
ARG GIT_VERSION
ARG EMSCRIPTEN_VERSION
ARG NODE_RELEASE

COPY --from=installer [ "C:\\7z\\", "C:\\7z\\" ]
COPY --from=installer [ "C:\\git\\", "C:\\git\\" ]
COPY --from=installer [ "C:\\emscripten\\", "C:\\emscripten\\" ]
COPY --from=installer [ "C:\\Users\\ContainerAdministrator\\.config\\", "C:\\Users\\ContainerAdministrator\\.config\\" ]
COPY --from=installer [ "C:\\Users\\ContainerAdministrator\\.jsvu\\", "C:\\Users\\ContainerAdministrator\\.jsvu\\" ]
COPY --from=installer [ "C:\\Program Files\\nodejs\\", "C:\\Program Files\\nodejs\\" ]
COPY --from=installer [ "C:\\Windows\\fonts\\arial.ttf", "C:\\Windows\\fonts\\arial.ttf" ]

ENV `
    ZIP7_VERSION=${ZIP7_VERSION} `
    GIT_VERSION=${GIT_VERSION} `
    GIT_INSTALLER=MinGit-${GIT_VERSION}-64-bit.zip `
    EMSCRIPTEN_VERSION=${EMSCRIPTEN_VERSION} `
    EMSCRIPTEN_PATH="C:\emscripten" `
    EMSDK_PATH="C:\emscripten\emsdk" `
    NODE_RELEASE=${NODE_RELEASE}

RUN setx /M PATH "%PATH%;C:\Program Files\nodejs\;C:\7z;C:\git\cmd;%USERPROFILE%\AppData\Roaming\npm;%USERPROFILE%\.jsvu\bin"
