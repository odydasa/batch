@ECHO OFF
SETLOCAL

SET _drive=%~1
SET _server=%~2
SET _path=%~3
IF "%_drive%"==""  CALL :drive
IF "%_server%"=="" CALL :server

IF NOT "%_drive:~-1%"==":" SET _drive=%_drive:~0,1%:
IF "%_server:~0,2%"=="\\" SET _server=%_server:~2%
SET _server=%_server:/=\%
SET _server=%_server:\\=\%
SET _server=\\%_server%
IF NOT "%_server:\=%"=="%_server%" (
  FOR /F "usebackq tokens=1,2* delims=\" %%A IN (`ECHO %_server%`) DO (
    CALL :run SET _path=%%_server:\\%%~A=%%
    SET _server=\\%%~A
  )
)
IF "%_path:~0,1%"=="\" SET _path=%_path:~1%


FOR %%A IN (_drive) DO CALL :toUpper %%~A
FOR %%A IN (_server) DO CALL :toLower %%~A

ECHO net use %_drive% %_server%\%_path% /savecred
>nul net use %_drive% /D
net use %_drive% %_server%\%_path% /savecred
net use %_drive%


ENDLOCAL
GOTO :EOF


:drive
SET /P _drive=Set Drive=
IF NOT DEFINED _drive GOTO :drive
IF "%_drive%"=="" GOTO :drive
IF NOT "%_drive%"=="%_drive:~0,1%" GOTO :drive
GOTO :EOF

:server
SET /P _server=Set Server=
IF NOT DEFINED _server GOTO :server
IF "%_server%"=="" GOTO :server
GOTO :EOF

:path
SET /P _path=Set Path [default: D$]=
IF "%_path%"=="" SET _path=$D
GOTO :EOF

:toLower
IF "%~1"=="" GOTO :EOF
IF NOT DEFINED %~1 GOTO :EOF
CALL :changeCase %~1 a b c d e f g h i j k l m n o p q r s t u v w x y z
GOTO :EOF

:toUpper
IF "%~1"=="" GOTO :EOF
IF NOT DEFINED %~1 GOTO :EOF
CALL :changeCase %~1 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
GOTO :EOF

:changeCase
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
CALL :run SET %~1=%%%~1:%~2=%~2%%
SHIFT /2
IF NOT "%~2"=="" GOTO :changeCase
GOTO :EOF

:run
%*
GOTO :EOF
