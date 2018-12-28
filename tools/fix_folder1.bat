@ECHO OFF
SETLOCAL
FOR /D %%A IN (20*) DO CALL :x %%A
ENDLOCAL
GOTO :EOF

:x
SET _tmp=%*
SET _tmp=%_tmp:~0,4%%_tmp:~5,2%%_tmp:~8%
REN "%*" "%_tmp%"
GOTO :EOF

:x1
SET _tmp=%*
SET _tmp=20%_tmp:~0,2%%_tmp:~3,2%%_tmp:~6%
ECHO REN "%*" "%_tmp%"
GOTO :EOF
