@ECHO OFF
SETLOCAL
SET _file=%tmp%\%~n0
SET _
GOTO :EOF
paste | sort > "%_file%"
notepad "%_file%"

