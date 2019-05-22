@ECHO OFF
SETLOCAL
SET _ThisFile=%~n0
SET _ContentReplace_valid_opt=-dump -regex -i -q -nv
SET _ContentReplace_options=
SET _ContentReplace_var1=
SET _ContentReplace_var2=
SET _ContentReplace_var3=
IF "%~1"=="" GOTO help
IF "%~2"=="" GOTO help

:check_var
IF "%~4*"=="*" GOTO next1
IF /I "%~4"=="-h" GOTO help
IF /I "%~4"=="-i" SET _ContentReplace_var2=TRUE
IF /I "%~4"=="-dump" SET _ContentReplace_var1=%_ContentReplace_var1%.
IF /I "%~4"=="-nv"   SET _ContentReplace_var1=%_ContentReplace_var1%.
IF /I "%~4"=="-q"    SET _ContentReplace_var1=%_ContentReplace_var1%.
SET _varOK=FALSE
FOR %%A IN (%_ContentReplace_valid_opt%) DO (
  IF /I "%~4"=="%%A" SET _varOK=TRUE
)
IF DEFINED _ContentReplace_var1 (
  SET _ContentReplace_var3=%_ContentReplace_var3% %~4
  IF "%_ContentReplace_var1:~0,2%"==".." SET _varOK=FALSE
)

IF /I NOT "%_varOK%"=="TRUE" (
  IF DEFINED _ContentReplace_var3 GOTO ilegal_param
  GOTO help
)
IF NOT DEFINED _ContentReplace_options (
  SET _ContentReplace_options=%4
) ELSE (
  SET _ContentReplace_options=%_ContentReplace_options% %4
)
SHIFT /4
GOTO check_var

:next1
IF NOT EXIST "%~1" GOTO nofile
IF /I NOT "%_ContentReplace_var2%"=="TRUE" IF "%~2"=="%~3" GOTO not_proccessed
SET _MyCMD=CALL "%~dp0callPHP" -f "%~dp0%~n0.php"
SET _ContentReplace_options="%~2" "%~3" %_ContentReplace_options%

FOR %%A IN ("%~1%") DO (
  :ECHO %_MyCMD% "%%~fA" %_ContentReplace_options%
  %_MyCMD% "%%~fA" %_ContentReplace_options%
)
GOTO end

:nofile
ECHO.
ECHO File not found!
ECHO.
GOTO help

:ilegal_param
ECHO.
ECHO There must be two or more ilegal parameter: %_ContentReplace_var3%
ECHO Don't use them together.
ECHO.
GOTO help


:help
ECHO %_thisfile%
ECHO Replace all occurrences of the search string with the replacement string
ECHO of given file
ECHO.
ECHO Using: %_thisfile% filename search_text [replace_text [options]]
ECHO.
ECHO Options:
ECHO   -dump    write result to stdout, don't use this with -q or -nv
ECHO   -regex   "search_text" acts as regex pattern
ECHO   -i       specifies that the text replace is not to be case-sensitive
ECHO   -q       quiet, no output, don't use this with -dump or -nv
ECHO   -nv      simple report, don't use this with -dump or -q
ECHO.
GOTO end

:not_proccessed
ECHO Not processed
GOTO end

:end
FOR %%A IN (ThisFile varOK myCMD) DO @SET _%%A=
FOR /F "delims==" %%A IN ('SET _ContentReplace') DO SET %%A=
ENDLOCAL
