@ECHO OFF
SETLOCAL
SET _target=%~f1
SET _source=%~f2
SET _found=
IF NOT DEFINED _source SET _source=%~dp0
FOR %%A IN (_source _target) DO CALL :run SET %%A=%%%%A:~0,-1%%
FOR /F "delims=" %%A IN ('DIR /AD /B *.*') DO CALL :job %%~A
IF NOT DEFINED _found ECHO Nothing's found
ENDLOCAL
GOTO :EOF

:run
%*
GOTO :EOF

:job
IF EXIST "%_target%\%**" (
  FOR /F "usebackq DELIMS=" %%A IN (`DIR /AD /B "%_target%\%**"`) DO (
  REN "%*" "%%A"
  ECHO "%*" ==^> "%%A"
  SET _found=TRUE
  GOTO :EOF
  )
)
GOTO :EOF