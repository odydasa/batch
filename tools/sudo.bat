@ECHO OFF
IF "%~1"=="" GOTO :EOF
CALL :checkEnv
IF DEFINED _setEnv CALL "%_setEnv%"
SETLOCAL
CALL :init

:setCmdFile
CALL :removeCmdFile
IF EXIST %_cmdFile% GOTO end
CALL :createCmdFile %*
REM IF EXIST %_cmdFile% ((ECHO. ) && TYPE %_cmdFile%
CALL "%_setEnv%"
runas /user:%_user% /savecred /env %_cmdFile%
REM runas /user:%_user% /savecred %1
CALL :removeCmdFile

:END
ENDLOCAL
GOTO :EOF

:init
SET _curDir=%~dp0
SET _curDir=%_curDir:~0,-1%
SET _cmdFile="%tmp%\~$sudo.bat"
IF NOT DEFINED _user SET _user=Administrator
GOTO :EOF

:checkEnv
SET _setEnv=
FOR %%A IN ("%ProgramFiles%" "%ProgramFiles(x86)%" "%_curDir%") DO (
  IF EXIST "%%~A\SetEnv.bat" SET _setEnv=%%~A\SetEnv.bat
  GOTO :EOF
)
GOTO :EOF

:removeCmdFile
IF NOT EXIST "%_cmdFile%" GOTO :EOF
ECHO.
:ECHO Deleting %_cmdFile%...
sleep 1
DEL /F /Q "%_cmdFile%"
GOTO :EOF

:createCmdFile
>  %_cmdFile% ECHO @ECHO OFF
>> %_cmdFile% ECHO %*

GOTO :EOF

