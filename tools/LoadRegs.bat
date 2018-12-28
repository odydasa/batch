@ECHO OFF
FOR %%A IN (target prefix) DO SET _LoadRegs_%%~A=
IF NOT "%~1"=="" (SET _LoadRegs_target=%~1) ELSE GOTO error
IF NOT "%~2"=="" SET _LoadRegs_prefix=%~2
FOR %%A IN ("%_LoadRegs_target%") DO SET _LoadRegs_target=%%~fA
SET _LoadRegs_tmp="%_LoadRegs_target%\temp"
SET _LoadRegs_tmp=%_LoadRegs_tmp:\\=\%
SET _LoadRegs_target=%_LoadRegs_target:\\=\%
IF "%_LoadRegs_target:~-1%"=="\" SET _LoadRegs_target=%_LoadRegs_target:~0,-1%
DIR /b /s "%_LoadRegs_target%\*.reg"|sort>%_LoadRegs_tmp%
FOR /F "usebackq delims=" %%A IN (`TYPE %_LoadRegs_tmp%`) DO CALL :fix %%~A
CALL :clear_tmp
GOTO end

:fix
SET _LoadRegs_tmp=%*
CALL ENVVAR SET _LoadRegs_tmp=%%_LoadRegs_tmp:%_LoadRegs_target%\=%%
ECHO %_LoadRegs_prefix%%_LoadRegs_tmp:~0,-4%
regedit -s "%*"
GOTO :EOF

:clear_tmp
IF DEFINED _LoadRegs_tmp IF EXIST %_LoadRegs_tmp% (
  attrib -a -r -s -h %_LoadRegs_tmp%
  DEL /F /Q %_LoadRegs_tmp%
)
GOTO :EOF

:error

:end
IF DEFINED _LoadRegs_target FOR /F "delims==" %%A IN ('SET _LoadRegs') DO SET %%A=
GOTO :EOF
