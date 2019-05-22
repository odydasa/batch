@ECHO OFF
SETLOCAL
FOR /D %%A IN (*.*) DO CALL :job %%A
ENDLOCAL
GOTO :EOF

:job
SET _x=%*
IF NOT EXIST "%_x:~0,4%\" MD "%_x:~0,4%\"
MOVE "%_x%" "%_x:~0,4%\"
GOTO :EOF
