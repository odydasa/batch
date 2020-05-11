@ECHO OFF
SETLOCAL
SET _app=notepad
SET _hosts=%SystemRoot%\System32\drivers\etc\hosts
SET _user=administrator

FOR %%A IN (%PATH%) DO IF EXIST "%%~A\%_app%2.exe" SET _app=%%~A\%_app%2
runas /user:%_user% /savecred "%_app% %_hosts%"
ENDLOCAL