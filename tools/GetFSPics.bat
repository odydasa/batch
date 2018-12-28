@ECHO OFF
SET _ThisFile=%~n0
SET _GetFSPics_tmpFile=%tmp%\~$GetFSPics_tmp%RANDOM%%RANDOM%%RANDOM%.txt
SET _GetFSPics_pattern=http\://photos\.friendster\.com/(.*)\.jpg
SET _GetFSPics_options=-i
SET _GetFSPics_txt1=m.jpg
SET _GetFSPics_txt2=l.jpg
SET _wgetCMD=wget -q -p
SET _fixCMD=CALL %~dps0ContentReplace
IF "%~1"=="" GOTO help
SET _getListCMD=CALL "%~dps0URL2List.bat" "%~1" "%_GetFSPics_pattern%" %_GetFSPics_options%
%_wgetCMD% -k %~1 > nul
%_getListCMD% > "%_GetFSPics_tmpFile%"
ECHO.>>"%_GetFSPics_tmpFile%"
TYPE "%_GetFSPics_tmpFile%">nul
%_fixCMD% "%_GetFSPics_tmpFile%" "%_GetFSPics_txt1%" "%_GetFSPics_txt2%" -i > nul
FOR /F "usebackq delims=" %%A IN (`TYPE "%_GetFSPics_tmpFile%"`) DO @(
  ECHO Downloading: %%~A
  %_wgetCMD% -m %%~A>nul
)
GOTO end

:nofile
ECHO.
ECHO File not found!
ECHO.
GOTO help

:help
ECHO Download pictures from Friendster 
ECHO.
ECHO Using: %_thisfile% URL pattern_text [options]
ECHO Options:
ECHO   -regex_quote   convert pattern_text into regex pattern
ECHO   -i             specifies that the searching is not to be case-sensitive
ECHO   -h             print this help
ECHO.
GOTO end

:end
CD /D "%_curDir%"
IF EXIST "%_GetFSPics_tmpDir%" RD /S /Q "%_GetFSPics_tmpDir%"
FOR %%A IN (ThisFile varOK myCMD fixCMD wgetCMD getListCMD curDir curPath) DO @SET _%%A=
FOR %%A IN (valid_opt options tmpDir tmpFile txt1 txt2) DO @SET _GetFSPics_%%A=
