@ECHO OFF
FOR /L %%A IN (1,0,2) DO FOR %%B IN (%*) DO (
  IF /I NOT "%%~xB"==".exe" (
    CALL :kill "%%~B.exe"
  ) ELSE (
    CALL :kill "%%~B"
  )
)
GOTO :EOF

:kill
ECHO %~1
taskkill /F /T /IM "%~1"
GOTO :EOF