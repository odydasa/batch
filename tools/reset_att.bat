@ECHO OFF
SETLOCAL
IF "%~1"=="" GOTO end
IF NOT EXIST "%~1" GOTO end
SET _cmd="%~dpn0"

:loop
IF "%~1"=="" GOTO end
SET _tgt=%~1
SET _tgt=%_tgt:/=\%
IF "%_tgt:~-1%"=="\" SET _tgt=%_tgt:~0,-1%
IF "%_tgt%"==".." SET _tgt=.
IF "%_tgt%"=="."  SET _tgt=%CD%
IF "%_tgt:~-1%"=="\" SET _tgt=%_tgt:~0,-1%
IF "%_tgt:~-1%"=="." SET _tgt=%_tgt:~0,-1%

SET _isDir=%~a1
IF "%_isDir:~0,1%"=="d" (SET _isDir=1) ELSE (SET _isDir=)

IF DEFINED _isDir (
  CALL :resetAtt "%_tgt%"
) ELSE (
  FOR /F "usebackq delims=" %%A IN (`forfiles /M "%_tgt%" /C "cmd /C ECHO @path"`) DO CALL :resetAtt "%%~A"
)


SHIFT
GOTO loop
GOTO end


:end
ENDLOCAL
GOTO :EOF

:parseList
SET _tmp=%*
SET _tmp=%_tmp:~22%
CALL :resetAtt "%_tmp%"
REM ECHO %_tmp%
GOTO :EOF

:resetAtt
IF "%~1"=="" SET _tmpTgt=
IF NOT EXIST "%~1" GOTO :EOF
SET _isDir=%~a1
IF "%_isDir:~0,1%"=="d" (SET _isDir=1) ELSE (SET _isDir=)
SET _param=/C /L
IF DEFINED _isDIr SET _param=/C /T /L

ECHO [] Grant access to Everyone
icacls "%~1" /grant "Everyone:F" %_param%
REM ECHO.

ECHO [] Set owner to Everyone
icacls "%~1" /setowner "\Everyone" %_param%
REM ECHO.

ECHO :: %~1
ECHO [] Resetting access...
icacls "%~1" /reset %_param%
REM ECHO.

ECHO [] Grant access to Everyone
icacls "%~1" /grant "Everyone:F" %_param%
REM ECHO.

ECHO [] Removing file blocking
IF DEFINED _isDir (
  streams -d -s "%~1"
) ELSE (
  streams -d "%~1"
)
REM ECHO.

ECHO [] Resetting attribut...
attrib -a -i "%~1" /L
IF DEFINED _isDir (
  attrib -a -i "%~1\*" /S /D /L
  FOR /F "usebackq delims=" %%A IN (`DIR /A-D /B /S "%~1\desktop.ini"`) DO IF EXIST "%%~fA" (
    attrib +r "%%~dpA"
    attrib -a +r +s +h "%%~fA"
  )
)
ECHO.
GOTO :EOF

