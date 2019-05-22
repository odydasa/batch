@ECHO OFF
SET _Unique=%TMP%\~$Unique%RANDOM%%RANDOM%%RANDOM%

:loop
IF "%~1*"=="*" GOTO end
FOR %%A IN ("%~1") DO CALL :process "%%~A"
SHIFT
GOTO loop

:process
IF NOT EXIST "%~1" GOTO :EOF
ECHO Sorting: %~1
sort "%~1" > "%_Unique%"
uniq "%_Unique%" > "%~1"
GOTO :EOF

:end
IF EXIST "%_Unique%" DEL "%_Unique%" /F /Q > nul
FOR /F "delims==" %%A IN ('SET _Unique') DO SET _%%A=
