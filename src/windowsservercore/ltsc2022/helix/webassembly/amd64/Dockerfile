# escape=`

ARG GIT_VERSION=2.34.1
ARG NODE_RELEASE=22

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:windowsservercore-ltsc2022-helix-amd64 as installer

ARG GIT_VERSION
ARG NODE_RELEASE

# Install arial font for chrome
COPY arial.ttf c:/windows/fonts

# Install git
ENV GIT_VERSION=${GIT_VERSION}
ENV GIT_INSTALLER=MinGit-${GIT_VERSION}-64-bit.zip

RUN curl -SL --output %TEMP%\%GIT_INSTALLER% https://github.com/git-for-windows/git/releases/download/v%GIT_VERSION%.windows.1/%GIT_INSTALLER% `
    && mkdir C:\git `
    && tar -C C:\git -zxf %TEMP%\%GIT_INSTALLER% `
    && setx PATH "%PATH%;C:\git\cmd"

# Enable long paths
RUN reg add HKLM\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 1 /f

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

# npm registry. Defaults to the public dotnet-public-npm Azure Artifacts feed, which is
# readable anonymously (works for local/dev and public builds). NPM_TOKEN is optional and
# only needed by internal builds that ingest new package versions into the feed.
ARG NPM_REGISTRY=https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public-npm/npm/registry/
ARG NPM_TOKEN

# hadolint ignore=SC1072
RUN npm config set registry %NPM_REGISTRY% `
    && if defined NPM_TOKEN ( `
        npm config set "%NPM_REGISTRY:https:=%:_authToken" %NPM_TOKEN% `
    )

# install latest jsvu and v8 engine
RUN npm install jsvu -g `
    && npm exec -c "jsvu --os=win64 --engines=v8" `
    && setx PATH "%PATH%;%USERPROFILE%\.jsvu\bin" `
    && %USERPROFILE%\.jsvu\bin\v8 -e "console.log(version());quit();" `
    && npm uninstall jsvu -g

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:windowsservercore-ltsc2022-helix-amd64

ARG GIT_VERSION
ARG NODE_RELEASE

COPY --from=installer [ "C:\\git\\", "C:\\git\\" ]
COPY --from=installer [ "C:\\Users\\ContainerAdministrator\\.config\\", "C:\\Users\\ContainerAdministrator\\.config\\" ]
COPY --from=installer [ "C:\\Users\\ContainerAdministrator\\.jsvu\\", "C:\\Users\\ContainerAdministrator\\.jsvu\\" ]
COPY --from=installer [ "C:\\Program Files\\nodejs\\", "C:\\Program Files\\nodejs\\" ]
COPY --from=installer [ "C:\\Windows\\fonts\\arial.ttf", "C:\\Windows\\fonts\\arial.ttf" ]

ENV `
    GIT_VERSION=${GIT_VERSION} `
    GIT_INSTALLER=MinGit-${GIT_VERSION}-64-bit.zip `
    NODE_RELEASE=${NODE_RELEASE}

RUN setx /M PATH "%PATH%;C:\Program Files\nodejs\;C:\git\cmd;%USERPROFILE%\AppData\Roaming\npm;%USERPROFILE%\.jsvu\bin"

# Enable long paths
RUN reg add HKLM\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 1 /f

# install vc redistributable for llvm 19
ENV VC_REDIST_VERSION 17

RUN curl -SL --output %TEMP%\vc_redist.x64.exe https://aka.ms/vs/%VC_REDIST_VERSION%/release/vc_redist.x64.exe `
    && %TEMP%\vc_redist.x64.exe /install /passive /norestart /wait `
    && del /q %TEMP%\vc_redist.x64.exe
