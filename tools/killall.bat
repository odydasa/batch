@ECHO OFF
SETLOCAL
SET _run=%~n0
SET _kill=taskkill /T /F /IM
:SET _kill=pskill -t
:loop
IF "%~1"=="" GOTO :EOF
IF /I "%~x1"=="" (
  CALL %_run% "%~n1.exe"
) ELSE (
  FOR %%A IN ("%~1") DO (
    ECHO Terminating: %%~nxA
    FOR /F "usebackq delims=" %%B IN (`%_kill% "%%~nxA"`) DO (
      ECHO   [] %%~nxB
    )
    ECHO.
  )
)
SHIFT
GOTO loop
ENDLOCAL
GOTO :EOF
