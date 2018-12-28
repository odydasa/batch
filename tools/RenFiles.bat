@ECHO OFF
IF "%~1"=="" GOTO :EOF
SETLOCAL
SET _x1="%~1"
SET _x2="%~2"
SET _x1=%_x1:&=^&%
SET _x2=%_x2:&=^&%
FOR %%A IN (*.*) DO CALL :x "%%~A"
ENDLOCAL
GOTO :EOF

:x2
GOTO :EOF

:x
SET _x=%*
CALL SET _x=%%_x:%_x1:~1,-1%=%_x2:~1,-1%%%
IF NOT %*==%_x% REN %* %_x%
GOTO :EOF

:run
%*
GOTO :EOF
