@ECHO OFF
SET _SysPaths="SystemRoot" "ProgramFiles(x86)" "ProgramFiles"
FOR %%A IN (%_sysPaths%) DO IF DEFINED %%~A CALL :addToVar _path %%A
SET _SysPaths=%_path%
SET _path=
FOR %%A IN (%PATH%) DO CALL :checkPath %%A
SET _path
SET _SysPaths
GOTO :EOF

:checkPath
IF "%~1"=="" GOTO :EOF
SET _tmp=%1
ECHO %_tmp%
FOR %%A IN (%_sysPaths%) DO CALL :convertPath _tmp %%A
REM CALL :addToVar _path %_tmp%
GOTO :EOF

:convertPath
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
ECHO %~2
GOTO :EOF
CALL :run SET _tmp1=%%%~2%%
SET _tmp2=##%~2##
REM ECHO _tmp= %_tmp1% = %_tmp2%
ECHO %_tmp1%
GOTO :EOF

:addToVar
IF "%~1"=="" GOTO :EOF
IF NOT DEFINED %1 (
  CALL :run SET %1=%2
) ELSE (
  CALL :run SET %1=%%%1%%;%2
)
GOTO :EOF

:run
%*
GOTO :EOF
