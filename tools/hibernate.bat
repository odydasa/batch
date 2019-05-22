@ECHO OFF
SETLOCAL
SET _time=%~1
IF NOT DEFINED _time SET _time=2
sleep %_time%
shtdwn /f /h
ENDLOCAL
