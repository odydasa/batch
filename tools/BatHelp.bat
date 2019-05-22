@ECHO OFF
FOR /F "usebackq delims=" %%A IN (`dir /b /on "%~dp0*.bat"`) DO @(
  ECHO %%~nA
  REM CALL %%~nA
  REM ECHO.
)