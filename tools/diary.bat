@ECHO OFF
SETLOCAL
FOR /F "delims=" %%A IN ('DATE /T') DO CALL :x %%A
ENDLOCAL
GOTO :EOF

:x
SET _x=%*
SET _x=%_x:~-2%%_x:~3,2%%_x:~0,2%
ECHO %_x%
GOTO :EOF
