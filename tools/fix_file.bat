@ECHO OFF
SETLOCAL
SET _validVar=minimized space help
IF "%*"=="" GOTO :EOF
FOR %%A IN (%_validVar%) DO IF /I "%*"=="%%~A" GOTO next
ECHO error!
GOTO :EOF

:next
IF /I "%*"=="minimized"	FOR %%A IN ("* (minimized).*") DO CALL :minimized %%~A
IF /I "%*"=="space"	FOR /F "usebackq delims=" %%A IN (`DIR /B`) DO CALL :fix_space %%A
ENDLOCAL
GOTO :EOF

:minimized
SET _x=%*
SET _x=%_x: (minimized)=%
ECHO Rename: %*
COPY /Y "%*" "%_x%" > nul
IF EXIST "%_x%" IF EXIST "%*" DEL /Q /F "%*"
GOTO :EOF

:fix_space
SET _x=%*
SET _x=%_x:_= %
SET _x=%_x:+= %
SET _x=%_x:  = %
SET _x=%_x:  = %
IF "%*"=="%_x%" GOTO :EOF
ECHO Rename: %*
REN "%*" "%_x%"
GOTO :EOF

:run
%*
GOTO :EOF
