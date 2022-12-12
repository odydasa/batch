@ECHO OFF
SETLOCAL
SET _arc=32
SET _params=enable disable reenable
SET _cmd=DevCon

IF DEFINED PROCESSOR_ARCHITECTURE IF "%PROCESSOR_ARCHITECTURE:~-2%"=="64" SET _arc=64
IF "%~1"=="" GOTO error
IF "%~2"=="" GOTO error
FOR %%A IN (%_params%) DO IF /I "%~1"=="%%~A" (
  SET _ops=%%~A
  IF /I "%%~A"=="reenable" SET _ops=disable enable
  GOTO next
)
GOTO error

:next


SET _DevName=%~2

SET _file=%Temp%\%Random%
FOR %%A IN ("%_file%" "%_file%1") DO IF EXIST "%%~A" DEL /F /Q "%%~A"
devcon findall * | grep -i "%_DevName%">"%_file%"
REM FOR /F "usebackq delims=:" %%A IN (`TYPE "%_file%"`) DO ECHO %%~A>>"%_file%1"
REM TYPE "%_file%1">"%_file%"
FOR /F "usebackq tokens=1,2 delims=:" %%A IN (`TYPE "%_file%"`) DO CALL :process "%%~A" "%%~B"
FOR %%A IN ("%_file%" "%_file%1") DO IF EXIST "%%~A" DEL /F /Q "%%~A"

:end
ENDLOCAL
GOTO :EOF

:error
ECHO Device control: enable, disable, re-enable
ECHO.
ECHO The syntax of this command is:
ECHO %~n0 %_params: =^|% Device_Name
GOTO end


:process
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
SET _DevID="%~1"
CALL :setID wireless-ac "PCI\VEN_8086&DEV_095B&SUBSYS_52108086&REV_59"

SET _DevName="%~2"
SET _DevName=%_DevName:(=[%
SET _DevName=%_DevName:)=]%
FOR %%A IN (%_ops%) DO (
  CALL :ECHO %_DevName:"=%
  ECHO ID: %_DevID%
  ECHO Set to: %%~A
  %_cmd% %%A %_DevID%
  ECHO.
)
GOTO :EOF


:setID
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
IF /I "%~1"=="%_DevName%" SET _DevID=%2
IF /I "%~1"=="%_DevName%" SET _DevID=%2
GOTO :EOF

:echo
ECHO %*
GOTO :EOF

enable
disable

Intel(R) Dual Band Wireless-AC 7265
PCI\VEN_8086&DEV_095B&SUBSYS_52108086&REV_59\4&5CE54D7&0&00E1
PCI\VEN_8086&DEV_095B&SUBSYS_52108086&REV_59\4&5CE54D7&0&00E1
PCI\VEN_8086&DEV_095B&SUBSYS_52108086&REV_59
PCI\VEN_8086&DEV_095B&SUBSYS_52108086
PCI\VEN_8086&DEV_095B&CC_028000

devcon listclass net|grep Wireless
