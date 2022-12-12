@ECHO OFF

:loop
FOR /F "delims=" %%A IN ('DATE /T') DO FOR /F "delims=" %%B IN ('TIME /T') DO ECHO ## %%A%%B
ECHO.
ipconfig /flushdns>nul
FOR %%A IN (gaper-f1 odydasa dr-indah avissena jenar) DO (
  ECHO %%A
  (ping -4 -a %%A | grep "Reply") || ECHO Not found: %%A
  ECHO.
)
ping google.com || (ECHO DNS Not working && (ping 1.1.1.1 || (ECHO No internet connection)))
ECHO.
ECHO.
GOTO loop

GOTO :end