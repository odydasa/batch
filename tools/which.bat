@ECHO OFF
SETLOCAL
IF "%~1"=="" GOTO help
FOR /F "delims=" %%A IN ('CD') DO SET CD=%%~fA
IF EXIST "%~1" (
  ECHO %1
  GOTO end
)
SET _val=
FOR %%A IN (%PATHEXT%) DO IF /I "%%~A"=="%~x1" SET _val=OK

IF DEFINED _val (
  CALL :which "%~1"
) ELSE (
  FOR %%A IN (%PATHEXT%) DO CALL :which "%~1%%A"
)

:end
ENDLOCAL
GOTO :EOF

:which
REM FOR %%A IN (%PATH%;"%CD%") DO IF EXIST "%%~A\%~1" ECHO %%~A\%~1
FOR %%A IN (%PATH%;"%CD%") DO FOR %%B IN ("%%~A\%~1") DO IF EXIST "%%~fB" ECHO %%~fB
GOTO :EOF

:help
ECHO.
ECHO %~nx0
ECHO Usage:  %~nx0 programname
ECHO.
ECHO   This will search the programname location in PATH
ECHO   programname without extension will based on PATHEXT
GOTO :EOF
