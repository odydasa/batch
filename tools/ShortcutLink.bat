@ECHO OFF
SETLOCAL
IF "%~1"=="" GOTO end
SET _tgt=%~f1
SET _lnk=%~f2
IF "%~2"=="" SET _lnk=%~dp1%~n1.lnk
powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%_lnk%'); $S.TargetPath = '%_tgt%'; $S.Save()"

:end
ENDLOCAL
GOTO :EOF