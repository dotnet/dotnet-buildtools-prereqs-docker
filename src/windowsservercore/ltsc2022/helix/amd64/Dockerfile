# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2022 AS helixsetup

RUN setx /M VIRTUAL_ENV "C:\Python-env" && `
    setx /M PATH "%PATH%;C:\Program Files\PowerShell\;%VIRTUAL_ENV%\Scripts;C:\Python;C:\python\scripts" && `
    setx /M PYTHONPATH "C:\Python\Lib;C:\Python\DLLs;"

# Install latest stable version of Python
RUN powershell -Command " `
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
        $apiUrl = 'https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public/nuget/v3/flat2/python/index.json'; `
        $response = Invoke-RestMethod -Uri $apiUrl; `
        $versions = @($response.versions | Where-Object { $_ -notmatch '-' } | Sort-Object { [version]$_ } -Descending); `
        $latestVersion = $versions[0]; `
        echo \"Downloading Python $latestVersion\"; `
        $pythonZip = \"$env:TEMP\python.zip\"; `
        Invoke-WebRequest -Uri https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-public/nuget/v3/flat2/python/$latestVersion/python.$latestVersion.nupkg -OutFile $pythonZip; `
        $pythonTemp = 'C:\PythonTemp'; `
        md $pythonTemp; `
        tar -zxf $pythonZip -C $pythonTemp; `
        if ($LASTEXITCODE -ne 0) { `
            echo 'Failed to extract Python'; `
            exit 1; `
        } `
        xcopy /s /i c:\PythonTemp\tools C:\Python; `
        if ($LASTEXITCODE -ne 0) { `
            echo 'Failed to copy Python'; `
            exit 1; `
        } `
        Remove-Item -Recurse -Force $pythonTemp; `
        Remove-Item -Force $pythonZip;"

ARG PIP_INDEX_URL=https://pypi.org/simple

# Install Helix
RUN powershell -Command " `
        $helixTemp = 'C:\helixtmp'; `
        md $helixTemp; `
        pushd $helixTemp; `
        python -m venv $env:VIRTUAL_ENV; `
        if ($LASTEXITCODE -ne 0) { `
            echo \"Failed to create Python virtual environment\"; `
            exit 1; `
        } `
        & pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple; `
        if ($LASTEXITCODE -ne 0) { `
            echo \"Failed to download Helix scripts\"; `
            exit 1; `
        } `
        Get-ChildItem -Path $helixTemp -Filter 'helix_scripts-*-py3-none-any.whl' | `
            ForEach-Object { `
                & pip install $_.FullName --no-cache-dir; `
                if ($LASTEXITCODE -ne 0) { `
                    echo \"Failed to install Helix script: $($_.Name)\"; `
                    exit 1; `
                } `
            }; `
        popd; `
        Remove-Item -Recurse -Force $helixTemp;"

FROM mcr.microsoft.com/windows/servercore:ltsc2022

USER ContainerAdministrator

COPY --from=helixsetup [ "C:\\Python\\", "C:\\Python\\" ]
COPY --from=helixsetup [ "C:\\Python-env\\", "C:\\Python-env\\" ]

RUN setx /M VIRTUAL_ENV "C:\Python-env" && `
    setx /M PATH "%PATH%;C:\Program Files\PowerShell\;%VIRTUAL_ENV%\Scripts;C:\Python;C:\python\scripts" && `
    setx /M PYTHONPATH "C:\Python\Lib;C:\Python\DLLs;"

# Configure crash dumps for dotnet.exe and corerun.exe
RUN powershell -Command " `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'dotnet.exe' -Force -ErrorAction SilentlyContinue; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpType -Force; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 'C:\cores' -Name DumpFolder -Force; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpCount -Force; `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'corerun.exe' -Force -ErrorAction SilentlyContinue; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpType -Force; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 'C:\cores' -Name DumpFolder -Force; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpCount -Force"

WORKDIR C:\\Work
