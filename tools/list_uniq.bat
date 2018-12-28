@ECHO OFF
SET _ThisFile=%~n0
SET _ListUniq_sort=sort
SET _ListUniq_uniq=uniq
SET _ListUniq_tmp=%tmp%\~$tmp_%~n0%RANDOM%%RANDOM%%RANDOM%%RANDOM%
IF "%~1"=="" GOTO help
SET _curDir=%CD%

:proccess
IF "%~1*"=="*" GOTO end
SET _varOK=FALSE
FOR %%A IN ("%~1") DO (
  IF EXIST "%%~A" (
    SET _varOK=TRUE
    CALL :uniq "%%~A"
  ) ELSE CALL :notfound "%%~A"
)
IF NOT "%_varOK%"=="TRUE" GOTO nofile %*
SHIFT
GOTO proccess

:check_tmpDir
GOTO end

:uniq
ECHO %~1
%_ListUniq_sort% "%~1" | %_ListUniq_uniq% > "%_ListUniq_tmp%"
TYPE "%_ListUniq_tmp%" > "%~1"
GOTO :EOF

:notfound
ECHO NOT found: "%~1"
ECHO. 

:nofile
ECHO.
ECHO %*.
ECHO File not found!
ECHO.
GOTO help

:help
ECHO Sort text list in file, and make them unique (no duplicate in list)
ECHO.
ECHO Using: %_thisfile% filename [options]
ECHO.
ECHO You can use wildchar (* OR ?) for filename
ECHO.
ECHO Options:
ECHO   -h             print this help
ECHO.
GOTO end

:end
CD /D "%_curDir%"
IF EXIST "%_ListUniq_tmp%" DEL /F /Q "%_ListUniq_tmp%"
FOR %%A IN (ThisFile varOK) DO @SET _%%A=
FOR /F "delims==" %%A IN ('SET _ListUniq') DO SET %%A=
