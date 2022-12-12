@ECHO OFF
SETLOCAL
SET _cmd=netsh advfirewall firewall set rule name=idm_block_##DIR## new enable=##ENABLE##
FOR %%A IN (in out) DO FOR %%B IN (no yes) DO CALL :job %%~A %%~B
REM pause>nul
ENDLOCAL
GOTO :EOF

:job
IF "%~2"=="" GOTO :EOF
IF "%~1"=="" GOTO :EOF
SET _tmp=%_cmd%
CALL :run SET _tmp=%%_tmp:##DIR##=%~1%%
CALL :run SET _tmp=%%_tmp:##ENABLE##=%~2%%
ECHO %_tmp%
%_tmp%>nul 2>&1
GOTO :EOF

:run
%*
GOTO :EOF