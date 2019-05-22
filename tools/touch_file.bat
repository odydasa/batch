@ECHO OFF
ECHO %*
SET _ThisFile=%~n0
SET _Touch_valid_opt=-b
SET _Touch_options=
IF "%~1"=="" GOTO help

:check_var
IF "%~2*"=="*" GOTO next1
IF /I "%~2"=="-h" GOTO help
SET _varOK=false
FOR %%A IN (%_Touch_valid_opt%) DO (
  IF /I "%~2"=="%%A" SET _varOK=true
)
IF NOT "%_varOK%"=="true" GOTO help
IF /I "%~2"=="-b" SET _Touch_var1=%2
SHIFT /2
GOTO check_var

:next1
IF /I "%_Touch_var1%"=="-b" CALL :make_file "%~1" > nul
IF NOT EXIST "%~1"          CALL :make_file "%~1" > nul
CALL :touch_file "%~1"
GOTO end

:touch_file
IF "%~1"=="" GOTO :EOF
TYPE "%~1">nul
GOTO :EOF

:make_file
IF "%~1"=="" GOTO :EOF
BREAK>"%~1"
GOTO :EOF

:nofile
ECHO.
ECHO File not found!
ECHO.
GOTO help

:help
ECHO Touch file
ECHO.
ECHO Using: %_thisfile% filename [-b] [-h]
ECHO.
ECHO Options:
ECHO   -b       make blank file
ECHO   -h       print this help
ECHO.
GOTO end

:not_proccessed
ECHO Not processed
GOTO end

:end
FOR %%A IN (ThisFile varOK myCMD) DO @SET _%%A=
FOR %%A IN (valid_opt options file txt1 txt2) DO @SET _Touch_%%A=
