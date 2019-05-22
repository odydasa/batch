@ECHO OFF
SETLOCAL
FOR /F "delims=" %%A IN ('DIR /AD /B *.*') DO CALL :job %%A
ENDLOCAL
GOTO:EOF

:job
SET _x=%*
SET _x=%_x:-=%
REN "%*" "%_x%"
GOTO :EOF