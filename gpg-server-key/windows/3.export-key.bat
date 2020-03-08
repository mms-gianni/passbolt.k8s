@echo off

if "%~1" == "" goto help

set KEY_ID=%~1
gpg --armor --export %KEY_ID% > serverkey.asc
gpg --armor --export-secret-keys %KEY_ID% > serverkey_private.asc
goto end

:help
echo.
echo       Help: 3.export-key.bat ^<KEY-ID^>
echo.

:end