@ECHO OFF
SETLOCAL
SET _run=%0
SET _script="%~dp0%~n0.vbs"
:loop
IF "%~1"=="" GOTO :EOF
SET _file=%~1
FOR %%A IN ("%_file%") DO (
  IF /I NOT "%%~xA"==".ppt" (
    IF EXIST "%%~A.ppt" CALL %_run% "%%~A.ppt"
  ) ELSE (
    CALL :ppt2pptx "%%~A"
  )
)
SHIFT
GOTO loop
ENDLOCAL
GOTO :EOF


:ppt2pptx
CSCRIPT %_script% "%~1" "%~n1.pptx"
GOTO :EOF