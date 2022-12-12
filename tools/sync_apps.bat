@ECHO OFF
SETLOCAL
SET _hosts=Gaper-F1;OdyDasa;dr-Indah;Avissena;Jenar
SET _dataOK=
SET _dataHeader=##DATA##
SET _dataList=

FOR /F "delims=" %%A IN ('TYPE "%~f0"') DO CALL :getData %%A
CALL :syncHost %_hosts%


GOTO :EOF

IF "%_src:~-1%"=="\" SET _src=%_src:~0,-1%
FOR %%X IN ("%_src") DO (
FOR %%D IN (V W X Y Z) DO IF EXIST %%D:\ (
FOR %%A IN () DO (
  MirrorFolder "%_src%\%%~A" "%%~D:%%~pX%%~A"  
)
) 
)

:syncHost
IF "%~1"=="" GOTO :EOF
IF /I "%~1"=="%COMPUTERNAME%" GOTO :syncHostSkip
>nul ping -4 -n 1 -w 50 %1
IF ERRORLEVEL 1 GOTO :syncHostSkip
>nul net use "\\%~1" /savecred
IF ERRORLEVEL 1 GOTO :syncHostSkip
ECHO ** %~1 **
FOR %%A IN (%_dataList%) DO IF EXIST "%%~A" CALL :mirroring "%%~A" "%~1"
ECHO.
:syncHostSkip
SHIFT
GOTO :syncHost
GOTO :EOF

:getData
SET _x=%*
SET _x=%_x:"=%
SET _x=%_x:"=%
IF "%_x%"=="%_dataHeader%" (
  SET _dataOK=OK
  GOTO :EOF
)
IF NOT DEFINED _x GOTO :EOF
IF NOT DEFINED _dataOK GOTO :EOF
IF "%_x:~0,1%"==";" GOTO :EOF
IF NOT DEFINED _dataList (
  SET _dataList="%_x%"
) ELSE (
  SET _dataList=%_dataList%;"%_x%"
)
GOTO :EOF

:mirroring
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
IF NOT EXIST "%~1" GOTO :EOF
SET _x=%~1
SET _x=\\%~2\%_x::=$%
CALL MirrorFolder "%~1" "%_x%"
GOTO :EOF

:run
%*
GOTO :EOF

##DATA##
D:\.data\System\Program Files\.tools\Batch
D:\.data\System\Program Files\.tools\Compress
D:\.data\System\Program Files\.tools\Exec
D:\.data\System\Program Files\.tools\Youtube
D:\.data\System\Program Files\BlinkSync
D:\.data\System\Program Files\Far Manager
D:\.data\System\Program Files\FMD
D:\.data\System\Program Files\IPXWrapper
D:\.data\System\Program Files\RDP Wrapper
