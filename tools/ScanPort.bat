@ECHO OFF
IF *%1==* GOTO :help
SET _target=%~1
SET _list=portscan-simple.txt
FOR /F "eol=# tokens=1,2* delims=	 " %%A IN (%_list%) DO (
  CALL :connect %_target% %%A "%%B %%C"
)

FOR %%A IN (target list) DO SET _%%A=
GOTO :EOF

:connect
ECHO %~1 %~2
echo quit|nc -t -w 10 -z %~1 %~2
GOTO :EOF

:help
ECHO This progrm will scan target host.
ECHO Usage: %~n0 host
GOTO :EOF