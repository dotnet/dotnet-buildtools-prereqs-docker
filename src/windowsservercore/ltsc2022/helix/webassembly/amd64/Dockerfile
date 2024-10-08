FROM mcr.microsoft.com/dotnet-buildtools/prereqs:windowsservercore-ltsc2022-helix-amd64

# Install 7zip
ENV ZIP7_VERSION=1900

RUN curl -SL --output %TEMP%\7zip-x64.exe https://www.7-zip.org/a/7z%ZIP7_VERSION%-x64.exe \
    && mkdir C:\7z \
    && %TEMP%\7zip-x64.exe /S /D="C:\7z" \
    && setx PATH "%PATH%;C:\7z"

# Install arial font for chrome
COPY arial.ttf c:/windows/fonts

# Install git
ENV GIT_VERSION=2.34.1
ENV GIT_INSTALLER=MinGit-${GIT_VERSION}-64-bit.zip

RUN curl -SL --output %TEMP%\%GIT_INSTALLER% https://github.com/git-for-windows/git/releases/download/v2.34.1.windows.1/%GIT_INSTALLER% \
    && mkdir C:\git \
    && tar -C C:\git -zxf %TEMP%\%GIT_INSTALLER% \
    && setx PATH "%PATH%;C:\git\cmd"

# install Node JS
ENV NODE_VERSION 18.17.1

RUN curl -SL --output %TEMP%\nodejs.msi https://nodejs.org/dist/v%NODE_VERSION%/node-v%NODE_VERSION%-x64.msi
RUN msiexec /i %TEMP%\nodejs.msi /quiet /passive /qn /norestart

# install latest jsvu and v8 engine
RUN npm install jsvu -g
RUN npm exec -c "jsvu --os=win64 --engines=v8"
RUN setx PATH "%PATH%;%USERPROFILE%\.jsvu\bin"
RUN v8 -e "console.log(version());quit();"

# install vc redistributable for llvm 19
ENV VC_REDIST_VERSION 17
RUN curl -SL --output %TEMP%\vc_redist.x64.exe https://aka.ms/vs/%VC_REDIST_VERSION%/release/vc_redist.x64.exe \
    && %TEMP%\vc_redist.x64.exe /install /passive /norestart /wait \
    && del /q %TEMP%\vc_redist.x64.exe
