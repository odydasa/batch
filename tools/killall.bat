@ECHO OFF
SETLOCAL
SET _run=%~n0
SET _kill=taskkill /T /F /IM
REM SET _kill=pskill -t
:loop
IF "%~1"=="" GOTO :EOF
IF /I "%~x1"=="" (
  CALL %_run% "%~n1.exe"
) ELSE (
  FOR %%A IN ("%~1") DO %_kill% "%%~A"
)
SHIFT
GOTO loop
ENDLOCAL
GOTO :EOF
