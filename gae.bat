@echo off
::|
::|Loads the configuration and optionally runs an SDK command.
::|
::|Environment is read from a configuration file that should
::|be located in the same directory as this script, and bave 
::|the same file name and a .conf extension (ie. gae.conf).
::|
::|If Python path is not set, common locations are searched
::|for Python 2.5. Using a newer version is not recommended now.
::|
::|Usage: gae [-v|--verbose] <command> [options] [arguments]
::|       gae --help 
::|

if "%~1"=="--help" goto :help

call :configure "%~dpn0.conf" 

if "%GAE_SDK%"=="" exit 1
if "%GAE_PYW%"=="" exit 1

if not "%~1"=="" call :run %*

goto :eof


:configure
call :testpath "GAE SDK" GAE_SDK "%GAE_SDK%" appcfg.py
call :testpath "Python"  GAE_PYW "%GAE_PYW%" python.exe

call :loadconf "%~1"

if "%GAE_PYV%"=="" set GAE_PYV=2.5

call :normpath "GAE SDK" GAE_SDK "%GAE_SDK%" "%~dp1"
call :testpath "GAE SDK" GAE_SDK "%GAE_SDK%" appcfg.py
call :testpath "Python"  GAE_PYW "%GAE_PYW%" python.exe

if "%GAE_PYW%"=="" call :locate "Python %GAE_PYV%" GAE_PYW "http://python.org/download/releases/%GAE_PYV%/" python.exe "Python%GAE_PYV:.=%" "Python%GAE_PYV%"
if "%GAE_SDK%"=="" echo *** Please configure GAE SDK path.>&2
goto :eof


:run
setlocal
set _log=
if not "%~1"=="-v" if not "%~1"=="--verbose" goto run_check
echo === Python:  %GAE_PYW%\python.exe>&2
echo === GAE SDK: %GAE_SDK%>&2
echo.>&2
set _log=1
shift
:run_check
if "%GAE_SDK%"=="" echo *** Please configure GAE SDK path.>&2
if "%GAE_SDK%"=="" goto :eof
if "%~1"=="" goto :eof
if exist "%GAE_SDK%\%~1" (
    set _cmd=%GAE_SDK%\%~1
) else if exist "%GAE_SDK%\%~1.py" (
    set _cmd=%GAE_SDK%\%~1.py
) else (
    echo *** GAE command not found: "%GAE_SDK%\%~1">&2
    exit 1
    )
set _pyw=%GAE_PYW%\python.exe
if not "%_pyw%"=="%_pyw: =%" set _pyw="%_pyw%"
if not "%_cmd%"=="%_cmd: =%" set _cmd="%_cmd%"
set _opt=
:run_opt
set _opt=%_opt% %2
shift /2
if not "%~2"=="" goto run_opt
if not "%~3"=="" goto run_opt
call :run2 %_cmd%%_opt%
endlocal
goto :eof
:run2
if "%~x1"==".py" goto run2py
if not "%_log%"=="" echo --- %*>&2
if not "%_log%"=="" echo.>&2
start "" %*
goto :eof
:run2py
if not "%_log%"=="" echo --- %_pyw% %*>&2
if not "%_log%"=="" echo.>&2
%_pyw% %*
goto :eof


:testpath
if "%~3"=="" goto :eof
if exist "%~3\%~4" goto :eof
echo *** Invalid %~1 path: "%~3">&2
set %~2=
goto :eof

:normpath
setlocal
set _=%~3
if "%_%"=="" goto skipnorm
if not "%_%"=="%_:/=\%" call :setenv _ "%_:/=\%"
if "%_:~0,2%"==".\" call :setenv _ "%~4%_:~2%"
:skipnorm
if 1==1 (
    endlocal
    call :setenv %2 "%_%"
    )
goto :eof

:locate
if "%~5"=="" (
    echo *** %~1 not located. You can download it at %~3 >&2
    goto :eof
    )
if exist "%SystemDrive%\%~5\%~4" (
    call :setenv %2 "%SystemDrive%\%~5"
    goto :eof
    )
if exist "%ProgramFiles%\%~5\%~4" (
    call :setenv %2 "%ProgramFiles%\%~5"
    goto :eof
    )
if not "%ProgramW6432%"=="" if exist "%ProgramW6432%\%~5\%~4" (
    call :setenv %2 "%ProgramW6432%\%~5"
    goto :eof
    )
shift /5
goto locate


:loadconf
if not exist "%~f1" (
    set GAE_CNF=
    echo *** Configuration file not found: "%~f1">&2
    goto :eof
    )
set GAE_CNF=%~f1
for /f "usebackq delims== tokens=1*" %%L in ("%~f1") do call :setcnf "%%L" "%%M" --newonly
goto :eof

:setcnf
if "%~1"=="" goto :eof
setlocal
set _=%~1
if "%_:~0,1%"=="#" goto :eof
set _=%~2
if "%_:~0,1%"=="'" if "%_:~-1%"=="'" (
    endlocal
    call :setenv %1 "%_:~1,-1%"
    goto :eof
    )
endlocal
:setenv
if "%~1"=="" goto :eof
if "%~3"=="--newonly" for /f "usebackq delims== tokens=1" %%V in (`set`) do if "%%V"=="%~1" goto :eof
set %~1=%~2
goto :eof


:help
for /f "usebackq delims=| tokens=1*" %%L in ("%~0") do (
    if "%%L"=="::" ( if "%%M"=="" ( echo. ) else echo %%M )
    )
