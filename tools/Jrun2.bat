@ECHO OFF
IF "%1*"=="*" (SET _srcTmp=Main) ELSE SET _srcTmp=%~n1
IF NOT EXIST %_srcTmp%.java GOTO :EOF
CLS
ECHO %_srcTmp%
javac %_srcTmp%.java
java  %_srcTmp% %2 %3 %4 %5 %6 %7 %8 %9
SET _srcTmp=
PAUSE >nul
