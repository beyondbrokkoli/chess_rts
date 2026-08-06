@echo off
setlocal enabledelayedexpansion

:: Force execution context to the script's directory (Project Root)
cd /d "%~dp0"

:: Check if binaries exist
if not exist "bin\boot.exe" (
    echo [ERROR] bin\boot.exe not found. Are you in the root directory?
    exit /b 1
)

set HOST_PORT=50000

if /I "%~1"=="" goto usage
if /I "%~1"=="swarm" goto swarm
if /I "%~1"=="lab" goto lab
if /I "%~1"=="host" goto host
if /I "%~1"=="client" goto client
if /I "%~1"=="attach" goto attach
goto usage

:usage
echo =======================================================
echo Weaver Engine Orchestrator (Windows)
echo =======================================================
echo Usage:
echo   launch.bat swarm [graphical_count] [bot_count]  - Spins up a local swarm cluster
echo   launch.bat lab                                  - Spins up 4/4 split (4 graphical, 4 bots)
echo   launch.bat host                                 - Boots a single graphical host node
echo   launch.bat client [port] [lobby_id]             - Boots a graphical client to join a lobby
echo   launch.bat attach [bot_count] [lobby_id]        - Injects headless bots to an existing lobby
echo =======================================================
exit /b 0

:host
echo [SWARM] Booting Graphical Host Node on port %HOST_PORT%...
set NODE_ROLE=host
start "Weaver Host" /B cmd /c "bin\boot.exe %HOST_PORT% > host.log 2>&1"
echo [SWARM] Tailing host.log...
powershell -command "Get-Content host.log -Wait"
exit /b 0

:client
if "%~2"=="" echo [ERROR] Missing port. & exit /b 1
if "%~3"=="" echo [ERROR] Missing lobby_id. & exit /b 1
echo [SWARM] Booting Graphical Client Node on port %2 joining Lobby %3...
set NODE_ROLE=client_manual
start "Weaver Client" /B cmd /c "bin\boot.exe %2 %3 > client_%2.log 2>&1"
exit /b 0

:attach
if "%~2"=="" echo [ERROR] Missing bot count. & exit /b 1
if "%~3"=="" echo [ERROR] Missing lobby_id. & exit /b 1
set BOT_COUNT=%2
set LOBBY_ID=%3
set START_PORT=50050
echo [SWARM] Injecting %BOT_COUNT% Headless Bots to Lobby %LOBBY_ID%...
for /L %%i in (1, 1, %BOT_COUNT%) do (
    set /A CLIENT_PORT=START_PORT + %%i
    set NODE_ROLE=bot_%%i
    start "Weaver Bot %%i" /B cmd /c "bin\boot_headless.exe !CLIENT_PORT! %LOBBY_ID% > client_!CLIENT_PORT!.log 2>&1"
    echo  ^|- Spun up Chaos Bot %%i (Port: !CLIENT_PORT!)
)
exit /b 0

:lab
call :swarm 3 4
exit /b 0

:swarm
set GRAPHICAL_CLIENTS=%~2
set BOT_CLIENTS=%~3
if "%GRAPHICAL_CLIENTS%"=="" set GRAPHICAL_CLIENTS=0
if "%BOT_CLIENTS%"=="" set BOT_CLIENTS=7

set /A TOTAL_PLAYERS=1 + GRAPHICAL_CLIENTS + BOT_CLIENTS
if %TOTAL_PLAYERS% GTR 8 (
    echo [SWARM] FATAL: Total players (%TOTAL_PLAYERS%) exceeds CFG_MAX_PLAYERS (8).
    exit /b 1
)

echo [SWARM] Orchestrating %TOTAL_PLAYERS%-Node Match...
echo [SWARM] Booting Graphical Host Node on port %HOST_PORT%...

set NODE_ROLE=host
start "Weaver Host" /B cmd /c "bin\boot.exe %HOST_PORT% > host.log 2>&1"

echo [SWARM] Waiting for Python Matchmaker to yield Lobby ID...
:wait_lobby
>nul find "LOBBY_ID:" host.log
if errorlevel 1 (
    timeout /t 1 /nobreak >nul
    goto wait_lobby
)

for /f "tokens=2 delims=:" %%A in ('findstr "LOBBY_ID:" host.log') do set RAW_LOBBY=%%A
:: Trim whitespace
set LOBBY_ID=%RAW_LOBBY: =%
echo [SWARM] Established Network Lobby: %LOBBY_ID%

set CLIENT_IDX=1

:: Inject Graphical Clients
if %GRAPHICAL_CLIENTS% GTR 0 (
    for /L %%i in (1, 1, %GRAPHICAL_CLIENTS%) do (
        set /A CLIENT_PORT=HOST_PORT + CLIENT_IDX
        set NODE_ROLE=client_!CLIENT_IDX!
        start "Weaver Client %%i" /B cmd /c "bin\boot.exe !CLIENT_PORT! %LOBBY_ID% > client_!CLIENT_PORT!.log 2>&1"
        echo  ^|- Spun up Graphical Client !CLIENT_IDX! (Port: !CLIENT_PORT!)
        set /A CLIENT_IDX+=1
    )
)

:: Inject Headless Bots
if %BOT_CLIENTS% GTR 0 (
    for /L %%i in (1, 1, %BOT_CLIENTS%) do (
        set /A CLIENT_PORT=HOST_PORT + CLIENT_IDX
        set NODE_ROLE=bot_!CLIENT_IDX!
        start "Weaver Bot %%i" /B cmd /c "bin\boot_headless.exe !CLIENT_PORT! %LOBBY_ID% > client_!CLIENT_PORT!.log 2>&1"
        echo  ^|- Spun up Chaos Bot !CLIENT_IDX! (Port: !CLIENT_PORT!)
        set /A CLIENT_IDX+=1
    )
)

echo [SWARM] Synchronization active. Tailing host heartbeat...
powershell -command "Get-Content host.log -Wait"
