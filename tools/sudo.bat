@ECHO OFF
SETLOCAL
IF "%~1"=="" GOTO :EOF
IF NOT DEFINED _user SET _user=Administrator
:setCmdFile
SET _cmdFile="%tmp%\~$sudo.bat"
IF EXIST %_cmdFile% GOTO setCmdFile
>  %_cmdFile% ECHO @ECHO OFF
>> %_cmdFile% ECHO %*
IF EXIST %_cmdFile% TYPE %_cmdFile%
runas /user:%_user% /savecred %_cmdFile%
sleep 1
IF EXIST %_cmdFile% DEL /F /Q %_cmdFile%
ENDLOCAL

:run
