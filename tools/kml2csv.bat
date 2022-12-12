@ECHO OFF
SETLOCAL
IF "%~1"=="" GOTO end
SET _csv=%~2
IF "%~2"=="" SET _csv=%~n1.csv
python "%~dp0%~n0.py" "%~1" "%_csv"

:end
ENDLOCAL
GOTO :EOF

