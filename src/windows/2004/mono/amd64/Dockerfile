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
RUN setx /M PATH "%PATH%;C:\Program Files\CMake\bin;C:\cygwin\bin"

WORKDIR C:\\Work
