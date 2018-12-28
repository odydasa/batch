@ECHO OFF
SETLOCAL
SET _user=%~1
IF NOT DEFINED _user SET _user=Administrator
runas /user:%_user% /savecred cmd.exe
ENDLOCAL
