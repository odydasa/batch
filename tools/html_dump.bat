@ECHO OFF
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
IF /I NOT "%~1"=="-links" IF /I NOT "%~1"=="-lynx" GOTO :EOF
SET _curPath=%CD%
SET _dumpCmd=%~1
SET _dumpParam=-dump -force_html
SET _dumpFile=%~2
SET _dumPath=%~dp2
SET _isLocal=TRUE
SET _tmpFile_html_dump=~$%RANDOM%%RANDOM%.tmp
SET HOME=%USERPROFILE%

SET _dumpCmd=%_dumpCmd:~1%
SET _dumPath=%_dumPath:~0,-1%

IF /I "%_dumpFile:~0,6%"=="ftp://"   SET _isLocal=FALSE
IF /I "%_dumpFile:~0,7%"=="http://"  SET _isLocal=FALSE
IF /I "%_dumpFile:~0,8%"=="https://" SET _isLocal=FALSE

IF /I %_isLocal%==FALSE (
  SET _dumpParam=%_dumpParam:-force_html=%
) ELSE (
  TYPE "%_dumpFile%">"%tmp%\%_tmpFile_html_dump%"
  SET _dumpFile=%_tmpFile_html_dump%
  CD /D "%tmp%"
)

IF /I "%~1"=="-lynx" (
  SET TERM=vt100
  SET LYNX_CFG=%HOME%\.lynx\lynx.cfg
  SET LYNX_LSS=%HOME%\.lynx\opaque.lss
  IF /I %_isLocal%==TRUE (
    SET _dumpFile=file://localhost/%CD:\=/%/%_dumpFile:\=/%
  )
) ELSE (
  SET _dumpParam=%_dumpParam:_=-%
  CALL ContentReplace "%_dumpFile%" "\r" "">nul
  CALL ContentReplace "%_dumpFile%" "\n" "">nul
)
SET _tmpFile_html_dump=%tmp%\%_tmpFile_html_dump%
%_dumpCmd% %_dumpParam% %_dumpFile%

CD /D "%_curPath%"
IF EXIST "%_tmpFile_html_dump%" (
  ATTRIB -a -r -s -h "%_tmpFile_html_dump%"
  DEL /F "%_tmpFile_html_dump%"
)
FOR %%A IN (curPath dumpCmd dumpParam dumpFile dumpPath tmpFile) DO SET _%%A=
FOR %%A IN (Name AllShort Path) DO SET _file%%A=
GOTO :EOF
