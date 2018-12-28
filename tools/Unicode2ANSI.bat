@ECHO OFF
SET _ThisFile=%~n0
SET _Unicode2ANSI_valid_opt=-dump
SET _Unicode2ANSI_options=
SET _Unicode2ANSI_var1=FALSE
SET _Unicode2ANSI_tmpFile=%tmp%\$~_Unicode2ANSI%RANDOM%%RANDOM%%RANDOM%.
IF "%~1"=="" GOTO help

:check_var
IF "%~2*"=="*" GOTO next1
IF /I "%~2"=="-h" GOTO help
SET _varOK=FALSE
FOR %%A IN (%_Unicode2ANSI_valid_opt%) DO (
  IF /I "%~2"=="%%A" SET _varOK=TRUE
  IF /I "%~2"=="-dump" SET SET _Unicode2ANSI_var1=TRUE
)
IF /I NOT "%_varOK%"=="TRUE" GOTO help
IF NOT DEFINED _Unicode2ANSI_options (
  SET _Unicode2ANSI_options=%2
) ELSE (
  SET _Unicode2ANSI_options=%_Unicode2ANSI_options% %2
)
SHIFT /2
GOTO check_var

:next1
IF NOT EXIST "%~1" GOTO nofile
SET _MyCMD=CALL %~dps0callPHP -f %~dps0%~ns0.php

FOR %%A IN ("%~1%") DO (
  TYPE "%%~fA" > "%_Unicode2ANSI_tmpFile%"
  IF /I "%_Unicode2ANSI_var1%"=="TRUE" (
  ) ELSE (
    TYPE "%_Unicode2ANSI_tmpFile%"
  )
    TYPE "%_Unicode2ANSI_tmpFile%" > "%%~fA"
)

GOTO end

:nofile
ECHO.
ECHO File not found!
ECHO.
GOTO help

:help
ECHO Convert Unicode format text file into ANSI format
ECHO.
ECHO Using: %_thisfile% [options]
ECHO.
ECHO Options:
ECHO   -dump    write result to stdout
ECHO   -h       print this help
ECHO.
GOTO end

:end
IF EXIST "%_Unicode2ANSI_tmpFile%" DEL /F /Q "%_Unicode2ANSI_tmpFile%"
FOR %%A IN (ThisFile varOK myCMD) DO @SET _%%A=
FOR /F "delims==" %%A IN ('SET _Unicode2ANSI') DO SET %%A=
