@ECHO OFF
SETLOCAL

SET _cmd=blinksync
SET _params=-m -r -u
SET _xd=nul,cat,con,.sync,_gsdata_
SET _xf=~$*.*,~*.tmp,Thumbs.db,*thumb*.dat,.sync*,.drop*,*.bts,*.!sync,*onfli*.*,.nomedia,desktop.ini

SET _resetACL=
SET _resetAtt=OK

CALL :init %*
IF NOT DEFINED _OK GOTO help
IF /I "%~1"=="-r" CALL :mirror -d "%_src%" "%_tgt%"
IF /I "%~1"=="-u" CALL :mirror "" "%_src%" "%_tgt%"
IF /I "%~1"=="-m" (
  CALL :mirror "" "%_src%" "%_tgt%"
  CALL :mirror "" "%_tgt%" "%_src%"
)
CALL :reset_att "%_src%"
CALL :reset_att "%_tgt%"

:help
REM ECHO %*
GOTO end

:end
ENDLOCAL
GOTO :EOF

:init
SET _OK=OK
IF "%~3"=="" SET _OK=
IF "%~2"=="" SET _OK=
IF "%~1"=="" SET _OK=
IF NOT DEFINED _OK GOTO :EOF
IF NOT EXIST "%~2" SET _OK=
FOR %%A IN (%_params%) DO IF /I "%~1"=="%%~A" GOTO init_next
SET _OK=

:init_next
SET _param=
IF DEFINED _xf SET _param=%_param% -xf %_xf%
IF DEFINED _xd SET _param=%_param% -xd %_xd%
SET _cmd=%_cmd% %_param%

SET _src=%~2
SET _tgt=%~3
SET _srcType=%~a2
IF /I NOT "%_srcType:~0,1%"=="d" SET _OK=
IF NOT DEFINED _OK GOTO :EOF

IF "%_src:~-1%"=="\" SET _src=%_src:~0,-1%
IF "%_tgt:~-1%"=="\" SET _tgt=%_tgt:~0,-1%
IF "%_src:~-3%"=="\.." SET _src=%_src:~0,-1%
IF "%_tgt:~-3%"=="\.." SET _tgt=%_tgt:~0,-1%
IF "%_src%"==".." SET _src=.
IF "%_tgt%"==".." SET _tgt=.

FOR %%A IN ("%_src%") DO SET _src=%%~fA
FOR %%A IN ("%_tgt%") DO SET _tgt=%%~fA

GOTO :EOF

:mirror
IF "%~3"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
IF NOT EXIST "%~3" MD "%~3"

ECHO Mirroring:
ECHO  Source: %~2
ECHO  Target: %~3
ECHO.
%_cmd% %~1 "%~2" "%~3"
ECHO.
GOTO :EOF

:reset_att
IF "%~1"=="" GOTO :EOF
IF /I "%_resetACL%"=="OK" (
  ECHO Set ACLS For: %~1
  FOR %%B in ("/reset" "/setowner \everyone" "/inheritance:e" "/grant everyone:F") DO (
    ECHO Set ACLS: %%~B 
    icacls "%~1" %%~B /C /T /L >nul 2>&1
  )
  ECHO.
)
IF /I "%_resetAtt%"=="OK" (
  ECHO Set atrribut: %~1
  ATTRIB -a -i "%~1" >nul 2>&1
  ECHO Set atrribut: %~1\*
  ATTRIB -a -i "%~1\*" /S /D /L >nul 2>&1
  ECHO.
)
GOTO :EOF

:run
%*
GOTO :EOF