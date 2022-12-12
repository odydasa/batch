::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCuDJBeA9VYxFChNXxCHMVeKFLob+un2r8yOrkgOaKwrd4DXyYisIfQQ4nn2cIU512hOp9wFChIWdxGkDg==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF65
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCuDJBeA9VYxFChNXxCHMVeKFLob+un2r8yOrkgOaKwrd4DXyYisIfQQ4nnWcIU512hOr8IqBVVdZhfL
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@ECHO OFF
SETLOCAL
SET _arc=32
SET _params=enable disable reenable
SET _cmd=DevCon

IF DEFINED PROCESSOR_ARCHITECTURE IF "%PROCESSOR_ARCHITECTURE:~-2%"=="64" SET _arc=64

SET _ops=disable enable
SET _DevName=wireless-ac

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
