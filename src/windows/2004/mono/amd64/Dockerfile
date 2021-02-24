# escape=`
FROM mcr.microsoft.com/windows:2004

USER ContainerAdministrator

# Download and install cmake
RUN curl -SL --output %TEMP%\cmake-x64.msi https://cmake.org/files/v3.9/cmake-3.9.6-win64-x64.msi `
    && powershell -Command `
        Start-Process %TEMP%\cmake-x64.msi -Wait -ArgumentList '/qn /norestart' ; `
        Remove-Item -Recurse -Force %TEMP%\*

# Download and install VC++ build tools
# This doesn't install in Server Core
RUN curl -SL --output %TEMP%\vcbuildtools.exe https://go.microsoft.com/fwlink/?LinkId=691126 `
    && powershell -Command `
        Start-Process %TEMP%\vcbuildtools.exe -Wait -ArgumentList '/full /quiet /norestart' ; `
        Remove-Item -Recurse -Force %TEMP%\*

# Download and install Clang/C2
RUN curl -SL --output %TEMP%\clangc2.exe "http://go.microsoft.com/fwlink/?LinkID=809031&clcid=0x409" `
    && powershell -Command `
        Start-Process %TEMP%\clangc2.exe -Wait -ArgumentList '/quiet /norestart' ; `
        Remove-Item -Recurse -Force %TEMP%\*

# Download VC++ 12.0 merge modules
# TODO: remove once MSI pkg-config.exe doesn't rely on those
RUN curl -SL --output "C:\Program Files (x86)\Common Files\Merge Modules\Microsoft_VC120_CRT_x86.msm" https://github.com/SpiderLabs/ModSecurity/raw/b6053df941f872b5c6ee8754837a8d5b21024769/iis/wix/Microsoft_VC120_CRT_x86.msm `
    && curl -SL --output "C:\Program Files (x86)\Common Files\Merge Modules\Microsoft_VC120_CRT_x64.msm" https://github.com/SpiderLabs/ModSecurity/raw/b6053df941f872b5c6ee8754837a8d5b21024769/iis/wix/Microsoft_VC120_CRT_x64.msm

# Install .NET 3.5, Wix dependency
# TODO: Remove when we move to Wix 4
RUN powershell -Command `
    Set-Service -Name wuauserv -StartupType "Manual" ; `
    DISM /Online /Enable-Feature /FeatureName:NetFx3 /All

# Download and install Wix
RUN curl -SL --output %TEMP%\wix.exe https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311.exe `
    && powershell -Command `
        Start-Process %TEMP%\wix.exe -Wait -ArgumentList '/q' ; `
        Remove-Item -Recurse -Force %TEMP%\*

# Setup CYGWIN
RUN setx /M CYGWIN "winsymlinks:lnk"

# Download and install cygwin
# Pack/unpack cycle due to https://github.com/microsoft/hcsshim/issues/835
RUN curl -SL --output %TEMP%\cygsetup.exe https://cygwin.com/setup-x86_64.exe `
    && powershell -Command `
        Start-Process %TEMP%\cygsetup.exe -Wait -ArgumentList '--quiet-mode --wait --root c:\cygwin --local-package-dir c:\cygwin --site http://mirrors.kernel.org/sourceware/cygwin/ --packages autoconf,automake,bison,gcc-core,gcc-g++,mingw64-i686-runtime,mingw64-i686-binutils,mingw64-i686-gcc-core,mingw64-i686-gcc-g++,mingw64-i686-pthreads,mingw64-i686-w32api,mingw64-i686-zlib,mingw64-x86_64-runtime,mingw64-x86_64-binutils,mingw64-x86_64-gcc-core,mingw64-x86_64-gcc-g++,mingw64-x86_64-pthreads,mingw64-x86_64-w32api,mingw64-x86_64-zlib,libtool,make,python,gettext-devel,gettext,intltool,libiconv,pkg-config,git,curl,wget,libxslt,bc,patch,cmake,libxml2-devel,libiconv-devel,zlib-devel,liblzma-devel,libssl-devel,bsdcpio,unzip,wget,p7zip,nohup,yasm' `
    && C:\cygwin\bin\bash.exe -c 'for i in `/bin/find / -xdev -type l`; do j=`/bin/readlink $i`; /bin/rm -f $i; /bin/ln -sf $j $i; done' `
    && powershell -Command `
        Remove-Item -Recurse -Force c:\cygwin\http* ; `
        Remove-Item -Recurse -Force %TEMP%\*

# Setup PATH
RUN setx /M PATH "%PATH%;C:\Program Files\CMake\bin;C:\python;C:\cygwin\bin"

WORKDIR C:\\Work
