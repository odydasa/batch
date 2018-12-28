@ECHO OFF
SETLOCAL
SET _target=%CD%
SET _prefix=
SET _suffix=.exe
SET _label=

IF NOT "%~1"=="" SET _target=%~1
IF NOT "%~2"=="" SET _prefix=%~2
IF NOT "%~3"=="" SET _suffix=%~3

IF "%_target:~-1%"=="\" SET _target=%_target:~0,-1%
IF NOT EXIST "%_target%\" SET _target=%CD:~0,-1%
IF NOT "%_suffix:~0,1%"=="." SET _suffix=.%_suffix%

FOR /F "usebackq delims=" %%A IN (`ECHO "%_target%\"`) DO (
  FOR /F "delims=" %%B IN ('DIR %%~dA') DO IF NOT DEFINED _label CALL :_set_label %%~B
)
CALL :_clean_file "%CD%%_prefix%%_label%%_suffix%"
FOR /F "usebackq delims=" %%A IN (`dir /ad /s /b "%_target%\"`) DO CALL :_clean_file "%%~fA\%_prefix%%%~nA%_suffix%"
ENDLOCAL
GOTO :EOF

:_set_label
IF DEFINED _label GOTO :EOF
SET _tmp=%*
IF "%_tmp:~0,15%"=="Volume in drive" SET _label=%_tmp:~21%
SET _tmp=
GOTO :EOF

:_clean_file
IF "%~1"=="" GOTO :EOF
IF NOT EXIST "%~1" GOTO :EOF
ECHO "%~1"
attrib -a -r -s -h "%~1"
DEL /F /Q "%~1"
GOTO :EOF
