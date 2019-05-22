@ECHO OFF
SETLOCAL
SET _ThisFile=%~n0
SET _myCMD=wget-.exe
SET _URL2List_valid_opt=-regex_quote -i
SET _URL2List_options=
IF "%~1"=="" GOTO help
IF "%~2"=="" GOTO help
SET _URL2List_tmpDir=%tmp%\~$tmp_%~n0%RANDOM%%RANDOM%%RANDOM%%RANDOM%
SET _curDir=%CD%

:check_var
IF "%~3*"=="*" GOTO check_tmpDir
IF /I "%~3"=="-h" GOTO help
SET _varOK=false
FOR %%A IN (%_URL2List_valid_opt%) DO (
  IF /I "%~3"=="%%A" SET _varOK=true
)
IF NOT "%_varOK%"=="true" GOTO help
IF NOT DEFINED _URL2List_options (
  SET _URL2List_options=%3
) ELSE (
  SET _URL2List_options=%_URL2List_options% %3
)
SHIFT /3
GOTO check_var

:check_tmpDir
IF NOT EXIST "%_URL2List_tmpDir%" GOTO next1
SET _URL2List_tmpDir=%tmp%\~$tmp_%~n0%RANDOM%%RANDOM%%RANDOM%%RANDOM%
GOTO check_URL2List_tmpDir

:next1
MD "%_URL2List_tmpDir%"
CD /D "%_URL2List_tmpDir%"
%_myCMD% -F -q %~1>nul
FOR /F "usebackq delims=" %%A IN (`DIR /B/S`) DO (
  SET _URL2List_file=%%~fA
)
IF NOT DEFINED _URL2List_file   GOTO nofile
IF NOT EXIST "%_URL2List_file%" GOTO nofile

SET _MyCMD=CALL %~dps0Search2List.bat
SET _URL2List_options="%~2" %_URL2List_options%

FOR %%A IN ("%_URL2List_file%") DO (
  %_MyCMD% "%%~fA" %_URL2List_options%
)
GOTO end

:nofile
ECHO.
ECHO File not found!
ECHO.
GOTO help

:help
ECHO Generate list from pattern search text of given URL
ECHO.
ECHO Using: %_thisfile% URL pattern_text [options]
ECHO Options:
ECHO   -regex_quote   convert pattern_text into regex pattern
ECHO   -i             specifies that the searching is not to be case-sensitive
ECHO   -h             print this help
ECHO.
GOTO end

:end
CD /D "%_curDir%"
IF EXIST "%_URL2List_tmpDir%" RD /S /Q "%_URL2List_tmpDir%"
FOR %%A IN (ThisFile varOK myCMD myCMD) DO @SET _%%A=
FOR %%A IN (valid_opt options tmpDir file) DO @SET _URL2List_%%A=
ENDLOCAL