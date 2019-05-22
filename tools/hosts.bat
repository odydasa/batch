@ECHO OFF
SETLOCAL
SET _user=Administrator
SET _host=%SystemRoot%\System32\drivers\etc\hosts
SET _notepad=notepad

FOR %%A IN (%PATH%) DO IF EXIST "%%~A\notepad2.exe" SET _notepad=%%~A\notepad2

runas /user:%_user% /savecred "%_notepad% %_host%"

ENDLOCAL
GOTO :EOF
