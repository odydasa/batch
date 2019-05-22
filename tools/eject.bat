@ECHO OFF
SETLOCAL
IF "%~1"=="" DO GOTO :EOF
FOR %%A IN (C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO IF /I "%~1"=="%%~A" GOTO next
GOTO :EOF

:next
CDisk /O /D=%~1
GOTO :EOF
