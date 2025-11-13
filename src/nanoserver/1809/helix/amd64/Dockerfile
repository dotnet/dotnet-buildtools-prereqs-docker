# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS installer

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN $apiUrl = 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest'; `
    $response = Invoke-RestMethod -Uri $apiUrl; `
    $url = $response.assets | Where-Object { $_.browser_download_url -match 'win-x64.zip' } | Select-Object -ExpandProperty browser_download_url; `
    Invoke-WebRequest -Uri $url -OutFile C:\powershell.zip; `
    Expand-Archive -Path C:\powershell.zip -DestinationPath C:\powershell; `
    Remove-Item -Path C:\powershell.zip


FROM mcr.microsoft.com/windows/nanoserver:1809 AS helixsetup

USER ContainerAdministrator

COPY --from=installer [ "C:\\powershell\\", "C:\\Program Files\\PowerShell\\" ]

RUN setx /M VIRTUAL_ENV "C:\Python-env" && `
    setx /M PATH "%PATH%;C:\Program Files\PowerShell\;%VIRTUAL_ENV%\Scripts;C:\Python;C:\python\scripts" && `
    setx /M PYTHONPATH "C:\Python\Lib;C:\Python\DLLs;"

# Install latest stable version of Python
RUN pwsh -Command " `
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
RUN pwsh -Command " `
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

FROM mcr.microsoft.com/windows/nanoserver:1809

USER ContainerAdministrator

COPY --from=helixsetup [ "C:\\Program Files\\PowerShell\\", "C:\\Program Files\\PowerShell\\" ]
COPY --from=helixsetup [ "C:\\Python\\", "C:\\Python\\" ]
COPY --from=helixsetup [ "C:\\Python-env\\", "C:\\Python-env\\" ]

RUN setx /M VIRTUAL_ENV "C:\Python-env" && `
    setx /M PATH "%PATH%;C:\Program Files\PowerShell\;%VIRTUAL_ENV%\Scripts;C:\Python;C:\python\scripts" && `
    setx /M PYTHONPATH "C:\Python\Lib;C:\Python\DLLs;"

# Configure crash dumps for dotnet.exe and corerun.exe
RUN pwsh -Command " `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'dotnet.exe' -Force -ErrorAction SilentlyContinue; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpType -Force; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 'C:\cores' -Name DumpFolder -Force; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\dotnet.exe' -Value 2 -Name DumpCount -Force; `
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\' -Name 'corerun.exe' -Force -ErrorAction SilentlyContinue; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpType -Force; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 'C:\cores' -Name DumpFolder -Force; `
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\corerun.exe' -Value 2 -Name DumpCount -Force"

WORKDIR C:\\Work
