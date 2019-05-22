@ECHO OFF
SETLOCAL

CALL :init %*
CALL :exec

ENDLOCAL
GOTO :EOF

:init
SET _txtUp=Up
SET _txtDown=Down
SET _txtParseStart=Pinging
SET _txtParseStop=Ping statistics
SET _txtReply=Reply
SET _txtParseStartLn=7
SET _txtParseStopLn=15
SET _txtReplyLn=5
IF NOT "%~1"=="" SET _target=%~1
IF NOT DEFINED _target SET _target=8.8.8.8
SET _cmd=ping -n 1 -w 2000 %_target%
GOTO :EOF

:exec
SET _parseTextPrev=%_parseText%
FOR %%A IN (Start Stop Text) DO SET _parse%%A=
FOR /F "usebackq delims=" %%A IN (`%_cmd%`) DO CALL :parse %%A
CALL :run IF /I "%%_parseText:~0,%_txtReplyLn%%%"=="%_txtReply%" SET _parseText=%_txtUp%
IF /I NOT "%_parseText%"=="%_txtUp%" SET _parseText=%_txtDown%
IF /I NOT "%_parseTextPrev%"=="%_parseText%" (
  ECHO %DATE%%TIME:~0,8%  ^|  %_target%  ^|  %_parseText%
)
IF /I "%_parseText%"=="%_txtDown%" (
  ECHO  > nul
)
:sleep 2s
GOTO :exec
GOTO :EOF

:parse
SET _tmp=%*
IF NOT DEFINED _parseStart (
  CALL :run IF /I "%%_tmp:~0,%_txtParseStartLn%%%"=="%_txtParseStart%" SET _parseStart=OK
  IF DEFINED _parseStart GOTO :EOF
) ELSE (
  CALL :run IF /I "%%_tmp:~0,%_txtParseStopLn%%%"=="%_txtParseStop%" SET _parseStop=OK
)
IF DEFINED _parseStart IF NOT DEFINED _parseStop SET _parseText=%* 
GOTO :EOF


:run
%*
GOTO :EOF