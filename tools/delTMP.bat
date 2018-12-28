@ECHO OFF
CALL :exec *.tmp
CALL :exec *.bak
CALL :exec ~$*.*
CALL :exec thumbs.db
GOTO :EOF

:exec
FOR /F "usebackq" %%A IN (`ATTRIB -a -r -s -h %1 /S`) DO SET _Param=%%A
IF A%_Param%A==AA (CALL :delete %1) ELSE CALL :not_exist %1
SET _Param=
GOTO :EOF


:not_exist
ECHO Not existing: %~1
GOTO :EOF

:delete
IF %1==*.tmp ATTRIB +h *.tmpl /S
DEL /S %1
IF %1==*.tmp ATTRIB -h *.tmpl /S
SET _Param=
GOTO :EOF
