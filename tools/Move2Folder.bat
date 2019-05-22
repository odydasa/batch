@ECHO OFF
SETLOCAL
IF "%~1"=="" GOTO end
FOR %%A IN (%*) DO IF NOT "%~1"=="%%~A" IF EXIST "*%%~A*.*" (
  IF NOT EXIST %1 MD %1
  MOVE "*%%~A*.*" %1
)
:end
ENDLOCAL
GOTO :EOF
