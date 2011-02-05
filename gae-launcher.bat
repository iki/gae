@echo off

if not exist "%HOME%\Google\google_appengine_launcher.ini" (
    call "%~dp0gae.bat"
    call :configure "%HOME%\Google\google_appengine_launcher.ini"
    )

"%~dp0gae.bat" --verbose launcher\GoogleAppEngineLauncher.exe %*

goto :eof

:configure
echo --- Setting Python path in "%~1">&2

if not exist "%~dp1." md "%~dp1."

echo # Google App Engine Launcher preferences> "%~1"
echo # http://code.google.com/appengine>> "%~1"
echo [preferences]>> "%~1"
echo python = %GAE_PYW%\pythonw.exe>> "%~1"

echo.>&2
