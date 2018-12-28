@ECHO OFF
SETLOCAL
SET _validParams=stop start restart
SET _cmd=net
SET _paramOK=
SET _job=%~1
SET _SvcName=%~2
IF "%_SvcName%"=="" SET _SvcName=
IF NOT DEFINED _SvcName SET _SvcName=%~n0
IF "%_jo%"=="" SET _job=
IF DEFINED _job (
  FOR %%A IN (%_validParams%) DO CALL :checkParam _paramOK "%%~A" "%_job%"
) ELSE (
  SET _paramOK=TRUE
  SET _job=restart
  CALL :note
)
IF /I "%_job%"=="restart" SET _job=stop start
IF /I "%_job%"=="restart" SET _job=stop start
IF /I "%_paramOK%"=="true" (
  FOR %%A IN (%_job%) DO CALL :exec_param %%A
) ELSE (
  CALL :help
)
GOTO end

:checkParam
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
IF /I "%~2"=="%~3" SET %~1=TRUE
GOTO :EOF

:exec_param
ECHO Execute "%_SvcName%" Windows Service command: %~1
%_cmd% %~1 %_SvcName%
ECHO.
GOTO :EOF

:note
ECHO.
ECHO Program CALL without param will restart "%_SvcName%" Windows Service
ECHO.
GOTO :EOF

:help
ECHO.
ECHO Usage:
ECHO   apache2 [[param] [ServiceName]
ECHO.
ECHO Param
ECHO   start:   start "%_SvcName%" service
ECHO   stop:    stop "%_SvcName%" service
ECHO   restart: restart "%_SvcName%" service
ECHO.
ECHO Servicename
ECHO   Name of Windows service
CALL :note
GOTO :EOF

:end
ENDLOCAL
