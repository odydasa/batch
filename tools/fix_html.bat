@ECHO OFF
SETLOCAL
SET _ThisFile=%~n0
SET _tmpFile_fix_html=%tmp%\~$fix_html_temp%RANDOM%%RANDOM%%RANDOM%.html
IF     A%1A==AA GOTO help
IF NOT A%4A==AA GOTO help
IF NOT A%3A==AA IF /I NOT A%3A==A--dumpA GOTO help
IF NOT EXIST "%~1" GOTO nofile

SET _MyCMD=CALL "%~dp0callPHP" -f "%~dp0%~n0.php"
FOR %%A IN ("%~1") DO @%_MyCMD% "%%~fA" "%~2" "%~3" %4
GOTO end


:nofile
ECHO.
ECHO File not found!
ECHO.
GOTO help

:help
ECHO.
ECHO Using: %_thisfile% filename [allowed_tags] [--dump]
ECHO.

:end
:FOR %%A IN (ThisFile CurFile TmpFile) DO @SET _%%A=
ENDLOCAL