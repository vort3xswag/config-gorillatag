@echo off
setlocal EnableDelayedExpansion

set "paths[1]=C:\Program Files (x86)\Steam\steamapps\common\Gorilla Tag"
set "paths[2]=C:\Program Files\Steam\steamapps\common\Gorilla Tag"
set "paths[3]=C:\Program Files\Oculus\Software\Software\another-axiom-gorilla-tag"
set "paths[4]=D:\SteamLibrary\steamapps\common\Gorilla Tag"
set "paths[5]=E:\SteamLibrary\steamapps\common\Gorilla Tag"

set "validIndex=0"
for /L %%i in (1,1,5) do (
    if exist "!paths[%%i]!" (
        set /a validIndex+=1
        set "validPaths[!validIndex!]=!paths[%%i]!"
    )
)


if %validIndex%==0 (
    echo No valid Gorilla Tag installation found.
    goto :manual
)


echo.
echo Select the Gorilla Tag install location:
for /L %%i in (1,1,%validIndex%) do (
    echo [%%i] !validPaths[%%i]!
)
echo [M] Enter custom path manually
echo.


set /p choice=Enter the number of your install path: 

for /L %%i in (1,1,%validIndex%) do (
    if "%choice%"=="%%i" (
        set "GTagPath=!validPaths[%%i]!"
        goto :found
    )
)

if /I "%choice%"=="M" (
    set /p GTagPath=Enter the full path to Gorilla Tag folder: 
    if not exist "%GTagPath%" (
        echo Invalid path. Try again.
        goto :manual
    )
    goto :found
)

echo Invalid selection. Try again.
goto :manual

echo Gorilla Tag found at: %GTagPath%

if not exist "%GTagPath%\Gorilla Tag.exe" (
    echo Gorilla Tag.exe not found!
    goto :missing
)
if not exist "%GTagPath%\BepInEx" (
    echo BepInEx folder not found!
    goto :missing
)
if not exist "%GTagPath%\BepInEx\config" (
    echo BepInEx config folder not found!
    goto :missing
)

echo All required files are present. Proceeding...
echo Downloading new config file...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://cdn.discordapp.com/attachments/1271902092570660894/1329251266919923804/BepInEx.cfg?ex=67b724f6&is=67b5d376&hm=fe3bc22366a1b985b4fc24cf30c20ed8f27c78b25138e47107eba881b750b91a', '%GTagPath%\BepInEx\config\BepInEx.cfg')"


if exist "%GTagPath%\BepInEx\config\BepInEx.cfg" (
    echo Config file successfully replaced!
) else (
    echo Failed to download config file.
)

pause
exit /b

:missing
echo Required files or folders are missing.
echo Please install Monkey Mod Manager from:
echo https://github.com/DeadlyKitten/MonkeModManager/releases/tag/1.3.1
start https://github.com/DeadlyKitten/MonkeModManager/releases/tag/1.3.1
pause
exit /b

:manual
echo Please enter a valid Gorilla Tag installation path.
set /p GTagPath=Enter full path: 
if not exist "%GTagPath%" (
    echo Invalid path. Try again.
    goto :manual
)
goto :found
