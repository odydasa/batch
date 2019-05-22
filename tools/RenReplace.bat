@ECHO OFF
SET _ThisFile=%~n0
IF     A%1A==AA GOTO help
IF     A%2A==AA GOTO help
IF     A%3A==AA GOTO help
IF NOT A%4A==AA GOTO help

FOR /F "usebackq delims=" %%A IN (`CALL %~0:build_list "%~1" "%~2"`) DO (
  ECHO %%~A
)

GOTO end

:build_list
DIR /B /ON "%~1"|grep "%~2"
GOTO :EOF

:set_var1
SET _var1=%~1
SET _
GOTO :EOF

:set_var2
SET _var2=%~1
GOTO :EOF


:nofile
ECHO.
ECHO File not found!
ECHO.
GOTO help

:help
ECHO.
ECHO Using: %_thisfile% "filename" "search_text" "replace_text" [--dump]
ECHO.

:end
:FOR %%A IN (ThisFile CurFile TmpFile) DO @SET _%%A=

