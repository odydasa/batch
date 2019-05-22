@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
IF "%~1"=="" GOTO :help
SET _lengths=16 24
REM FOR /L %%A IN (0,1,3) DO SET _Address[%%~A]=0
CALL :parseAddress %~1
IF NOT DEFINED _length GOTO :help

FOR /L %%A IN (%_Address[2].Start%,1,%_Address[2].Stop%) DO FOR /L %%B IN (%_Address[3].Start%,1,%_Address[3].Stop%) DO (
  FOR /F "usebackq" %%C IN (`PING %_Address[0]%.%_Address[0]%.%%~A.%%~B -n 1 -i 1 -l 1 -w 1`) DO (
    IF "%%~C"=="Reply" (
      ECHO %_Address[0]%.%_Address[1]%.%%~A.%%~B: Connected
    ) ELSE (
      REM ECHO %_Address[0]%.%_Address[1]%.%%~A.%%~B:
    )
  )
)
GOTO :end

:help
ECHO Usage:
ECHO   %~n0 address/length
ECHO/
ECHO  Valid length: %_lengths%
ECHO/
ECHO Example
ECHO   %~n0 192.168.1.1/24
GOTO :end

:end
ENDLOCAL
GOTO :EOF

:parseAddress
IF "%~1"=="" GOTO :EOF
FOR %%A IN (_address _length) DO SET %%~A=
FOR /F "tokens=1,2,1-2 delims=/" %%A IN ('ECHO %~1') DO (
  SET _Address=%%~A
  FOR %%C in (%_lengths%) DO IF "%%~B"=="%%~C" SET _length=%%~B
)
FOR %%A IN (Start Stop) DO (
  SET n=0
  FOR %%B IN (%_Address:.= %) DO (
    SET _Address[!n!]=%%B
    IF !n! GTR 1 SET _Address[!n!].%%~A=%%B
    SET /A n+=1
  )
)
FOR %%A IN (Start.1 Stop.254) DO (
  FOR /F "tokens=1,2,1-2 delims=." %%B IN ('ECHO %%~A') DO (
    SET _Address[3].%%~B=%%C
    IF "%_length%"=="16" SET _Address[2].%%~B=%%C
  )
)
GOTO :EOF

:run
%*
GOTO :EOF