@ECHO OFF
SETLOCAL
SET _cmd=rar a -r0 -s -m5 -md1024 -isnd -y 

:proccess
IF "%~1*"=="*" GOTO end
FOR %%A IN ("%~1") DO (
  IF EXIST "%%~A\" (
     %_cmd% "%%~A.rar" "%%~A\"
     RD /S /Q "%%~A\"
  ) ELSE IF EXIST "%%~A" (
     %_cmd% "%%~nA.rar" "%%~A"
     ATTRIB -a -r -s -h "%%~A"
     DEL /F /Q "%%~A"
  ) ELSE CALL :error "%%~A" "Not found"
)
SHIFT
GOTO proccess

:error
ECHO ERROR processing "%~1"
ECHO : %~2
ECHO. 

:notfound
ECHO NOT found: "%~1"
ECHO. 

:end
FOR %%A IN (cmd) DO SET _%%A=
ENDLOCAL
