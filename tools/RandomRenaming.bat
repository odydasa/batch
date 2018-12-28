@ECHO OFF

:proccess
IF "%~1*"=="*" GOTO end
FOR %%A IN ("%~1") DO (
  IF EXIST "%%~A" (
     REN "%%~A" "%RANDOM%%RANDOM%%RANDOM%%RANDOM%%%~xA"
  ) ELSE CALL :error "%%~A" "Not found"
)
SHIFT
GOTO proccess

:error
ECHO ERROR processing "%~1"
ECHO : %~2
ECHO. 

:end
FOR %%A IN (cmd) DO SET _%%A=
