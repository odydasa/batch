@ECHO OFF
SET _ThisFile=%~n0
SET _Search2List_valid_opt=-regex_quote -i
SET _Search2List_options=
IF "%~1"=="" GOTO help
IF "%~2"=="" GOTO help

:check_var
IF "%~3*"=="*" GOTO next1
IF /I "%~3"=="-h" GOTO help
SET _varOK=false
FOR %%A IN (%_Search2List_valid_opt%) DO (
  IF /I "%~3"=="%%A" SET _varOK=true
)
IF NOT "%_varOK%"=="true" GOTO help
IF NOT DEFINED _Search2List_options (
  SET _Search2List_options=%3
) ELSE (
  SET _Search2List_options=%_Search2List_options% %3
)
SHIFT /3
GOTO check_var

:next1
IF NOT EXIST "%~1" GOTO nofile
SET _MyCMD=CALL %~dps0callPHP -f %~dps0%~ns0.php
SET _Search2List_options="%~2" %_Search2List_options%

FOR %%A IN ("%~1%") DO (
  %_MyCMD% "%%~fA" %_Search2List_options%
)
GOTO end

:nofile
ECHO.
ECHO File not found!
ECHO.
GOTO help

:help
ECHO Generate list from pattern search text of given file
ECHO.
ECHO Using: %_thisfile% filename pattern_text [options]
ECHO Options:
ECHO   -regex_quote   convert pattern_text into regex pattern
ECHO   -i             specifies that the searching is not to be case-sensitive
ECHO   -h             print this help
ECHO.
GOTO end

:not_proccessed
ECHO Not processed
GOTO end

:end
FOR %%A IN (ThisFile varOK myCMD) DO @SET _%%A=
FOR %%A IN (valid_opt options) DO @SET _Search2List_%%A=
