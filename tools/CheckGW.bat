@ECHO OFF
SETLOCAL EnableDelayedExpansion
CALL :init

:loop
ipconfig /flushdns >nul 2>&1
FOR %%A IN (_GWConnect _inetConnect) DO SET %%~A=
CALL :incVar _Nr
CALL :getDateTime _DateTime
ECHO #%_Nr% %_LF%%_DateTime%
ECHO.
ECHO Connection to Gateway:
CALL :checkGW
IF NOT DEFINED _GWConnect (
   ECHO No available Gateway.
   ECHO Check connection to Gateway!
   IF "%_listGW%"=="" CALL :beep
   sleep 2s
) ELSE (
   ECHO.
   ECHO Connection to Internet:
   CALL :checkInet %_listInet%
   IF NOT DEFINED _inetConnect (
     ECHO Check Intenet connection!
     sleep 2s
   )
)
ECHO.
ECHO.
GOTO :loop

:init
SET _LF=^&ECHO(
SET _Nr=0
SET _listInet=
CALL :addVar _listInet google.com 
CALL :addVar _listInet microsoft.com 
CALL :addVar _listInet facebook.com 
REM SET _listInet
REM ECHO %_listInet%
GOTO :EOF

:run
%*
GOTO :EOF

:incVar
IF "%~1"=="" GOTO :EOF
IF NOT DEFINED %~1 SET %~1=0
IF "%~2"=="" (
  SET /A %~1+=1
) ELSE (
  SET /A %~1+=%~2
)
GOTO :EOF

:addVar
IF "%~1"=="" GOTO :EOF
IF NOT DEFINED %~1 (
  SET %~1=%2
) ELSE (
  CALL :run SET %~1=%%%~1%%;%2
)
REM CALL :run ECHO %%%~1%%
GOTO :EOF
	
:getDateTime
IF "%~1"=="" GOTO :EOF
FOR /F "delims=" %%A IN ('date /T') DO (
  FOR /F "delims=" %%B IN ('time /T') DO (
    SET %~1=%%~A%%~B
  )
)
GOTO :EOF

:beep
ECHO 
GOTO :EOF

:ping
IF "%~1"=="" GOTO :EOF
SET _tgt=%*
IF NOT "%_tgt%"=="%_tgt::=%" GOTO :EOF
SET ERRORLEVEL=
ECHO Check connection to: %*
((ping -4 %* | find "TTL") && SET ERRORLEVEL=0) || SET ERRORLEVEL=1
IF "%ERRORLEVEL%"=="1" (
  ECHO   Connection error!
)
ECHO ErrorLevel: %ERRORLEVEL%
GOTO :EOF

:checkGW
FOR %%A IN (_listGW _txtTmp _txtVar _txtVal) DO SET %%~A=
FOR /F "delims=" %%A IN ('ipconfig') DO CALL :parseIPConfig "%%~A"
CALL :checkGWList %_listGW%
GOTO :EOF

:checkGWList
IF "%~1"=="" GOTO :EOF
CALL :ping %~1
REM ECHO %ERRORLEVEL%
IF "%ERRORLEVEL%"=="0" SET _GWConnect=OK
IF "%ERRORLEVEL%"=="1" SET _GWConnect=
SHIFT
GOTO :checkGWList
GOTO :EOF

:checkInet
IF "%~1"=="" GOTO :EOF
CALL :checkInetList %*
GOTO :EOF

:checkInetList
IF "%~1"=="" GOTO :EOF
IF /I "%_inetConnect%"=="OK" GOTO :EOF
CALL :ping %~1
REM ECHO %ERRORLEVEL%
IF "%ERRORLEVEL%"=="0" SET _inetConnect=OK
IF "%ERRORLEVEL%"=="1" SET _inetConnect=
SHIFT
GOTO :checkInetList
GOTO :EOF

:parseIPConfig
IF "%~1"=="" GOTO :EOF
SET _txtTmp=%~1
SET _txtTmp=%_txtTmp:  .=%
SET _txtTmp=%_txtTmp: .=%
SET _txtTmp=%_txtTmp:  : = : %
SET _txtTmp=%_txtTmp:  : = : %
SET _txtTmp=%_txtTmp:. : = : %
SET _txtTmp=%_txtTmp: : =%
SET _txtVal=
IF NOT "%_txtTmp%"=="%_txtTmp:=%" (
  FOR /F "tokens=1,2,1-2 delims=" %%A IN ("%_txtTmp: =%") DO CALL :getGW %%~A %%~B
) ELSE (
  IF /I "%_txtVar%"=="DefaultGateway" IF "%_txtTmp:~0,1%"==" " (
    SET _txtVal="%_txtTmp: =%"
  )
)
IF NOT DEFINED _txtVal GOTO :EOF
FOR %%A IN (%_txtVal%) DO SET _txtVal=%%~A
ECHO %_txtVal%
FOR %%A IN (%_listGW%) DO IF "%%~A"=="%_txtVal%" GOTO :EOF
CALL :addVar _listGW %_txtVal%
GOTO :EOF

:getGW
IF "%~1"=="" GOTO :EOF
IF /I NOT "%~1"=="DefaultGateway" GOTO :EOF
SET _txtVar=%~1
SET _txtVal=%~2
GOTO :EOF
