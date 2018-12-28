@ECHO OFF

IF "%~1*"=="*" GOTO help
IF "%~2*"=="*" GOTO help
SET _tmpList=%tmp%\$$$$$$$$.$$$
SET _counter=0
SET _prefix=%~1
SET _suffix=%~2
SET _filename=%~3
IF NOT DEFINED _filename SET _filename=*.*

IF NOT %_suffix:~0,1%==. SET _suffix=.%2
IF EXIST "%_tmpList%" DEL /F /Q "%_tmpList%"
FOR %%A IN ("%_filename%") DO ECHO %%A >> "%_tmpList%"
SORT "%_tmpList%" > "%_tmpList%1"
TYPE "%_tmpList%1" > "%_tmpList%"
IF EXIST "%_tmpList%" DEL /F /Q "%_tmpList%1"
FOR /F "usebackq delims=" %%A IN (`TYPE "%_tmpList%"`) DO (
  CALL :ren_filename "%%~A"
)
FOR %%A IN (tmpList counter prefix suffix) DO SET _%%A=
GOTO :EOF

:ren_filename 
IF NOT EXIST "%~1" GOTO :EOF
REN "%~1" "%_prefix%%_counter%%_suffix%"
SET /A _counter +=1
GOTO :EOF

:help
ECHO Usage:
ECHO   %~n0 prefix_name suffix_name [filename]
ECHO.
ECHO   Filename could be wildchart, if not provided then be: *.*
