@ECHO OFF
FOR /F "delims=" %%A IN ('TIME /T') DO ECHO %%A: Releasing...
> nul ipconfig /release
FOR /F "delims=" %%A IN ('TIME /T') DO ECHO %%A: Renewing...
> nul ipconfig /renew
TIME /T
ipconfig /all

pause
