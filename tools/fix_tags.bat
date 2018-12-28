@ECHO OFF
SET _ThisFile=%~n0
SET _fix_tags_tmpFile=%tmp%\~$fix_html_temp%RANDOM%%RANDOM%%RANDOM%.html
SET _fix_tags_valid_opt=-dump
SET _fix_tags_options=

IF "%~1"=="" GOTO help
:check_var
IF "%~3*"=="*" GOTO next1
IF /I "%~3"=="-h" GOTO help
SET _varOK=FALSE
FOR %%A IN (%_fix_tags_valid_opt%) DO (
  IF /I "%~3"=="%%A" SET _varOK=TRUE
  IF /I "%~3"=="-dump" SET SET _fix_tags_var1=TRUE
)
IF /I NOT "%_varOK%"=="TRUE" GOTO help
IF NOT DEFINED _fix_tags_options (
  SET _fix_tags_options=%3
) ELSE (
  SET _fix_tags_options=%_fix_tags_options% %3
)
SHIFT /3
GOTO check_var

:next1
IF NOT EXIST "%~1" GOTO nofile
SET _MyCMD=CALL %~dps0callPHP -f %~dps0%~ns0.php
  SET _fix_tags_options="%~3" %_fix_tags_options%

FOR %%A IN ("%~1%") DO (
  %_MyCMD% "%%~fA" %_fix_tags_options%
)

GOTO end


:nofile
ECHO.
ECHO File not found!
ECHO.
GOTO help

:help
ECHO Strip HTML code
ECHO.
ECHO Using: %_thisfile% ["allowed_tags" [options]]
ECHO.
ECHO   Type tags will be allowed, sparated by space, or
ECHO   just let it blank.
ECHO.
ECHO   allowed_tags: 
ECHO      ""    default allowed tags: p br h1 h2 h3
ECHO      -     no tag allowed
ECHO.
ECHO Options:
ECHO   -dump    write result to stdout
ECHO   -h       print this help
ECHO.
GOTO end

:end
IF EXIST "%_fix_tags_tmpFile%" DEL /F /Q "%_fix_tags_tmpFile%"
FOR %%A IN (ThisFile varOK myCMD) DO @SET _%%A=
FOR /F "delims==" %%A IN ('SET _fix_tags') DO SET %%A=

