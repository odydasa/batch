@ECHO OFF
SETLOCAL
FOR %%A IN (*.*) DO CALL :fix %%A
ENDLOCAL
GOTO :EOF

:fix
SET _x=%*
CALL :fixName "[" "("
CALL :fixName "]" ")"
CALL :fixName "( " "("
CALL :fixName " )" ")"
CALL :fixName "240p"
CALL :fixName "360p"
CALL :fixName "1080p"
CALL :fixName "Youtube"
CALL :fixName "YouTube"
CALL :fixName "HD"
CALL :fixName "HQ"
CALL :fixName "Official"
CALL :fixName "Teaser"
CALL :fixName "(HD)"
CALL :fixName "(Full)"
CALL :fixName "()"
CALL :fixName "[]"
CALL :fixName "--" "-"
CALL :fixName "-." "."
CALL :fixName "-." "."
CALL :fixName "-." "."
CALL :fixName " ." "."
CALL :fixName " ." "."
CALL :fixName " ." "."
CALL :fixName "!!" "!"
CALL :fixName "!!" "!"
CALL :fixName "!!" "!"
CALL :fixName "!." "."
CALL :fixName ".." "."
CALL :fixName ".." "."
CALL :fixName ".." "."
CALL :fixName "_" " "
CALL :fixName "  " " "
CALL :fixName "  " " "
CALL :fixName "  " " "
::FOR /L %%A IN (1990,1,2013) DO CALL :fixName "(%%~A)" "[%%~A]"
IF "%*"=="%_x%" GOTO :EOF
ECHO %*
REN "%*" "%_x%"
GOTO :EOF

:fixName
CALL SET _x=%%_x:%~1=%~2%%
GOTO :EOF
