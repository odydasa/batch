@ECHO OFF
:: Version 20190211
::  - fixed HOME setting
::
:: Version 20190205
::  Grab minor bug in WinXP:
::  - some parts require any previous command, at least ECHO.>nul
::  - leave bug with REM
::
:: Version 20190201
::   Restructuring alogithm
::
::
::

CALL :fullPath _CD "%CD%"
CALL :init

FOR %%A IN ("%ProgramData%") DO IF EXIST "%%~fA" (
  ECHO :: Setting path from %%~fA
  CD /D "%%~fA"
  CALL :addPathList "Oracle\Java\javapath" 
  CD /D "%_CD%\"
  ECHO :: Setting path from %%~fA: done.
  ECHO.
)

FOR %%A IN ("%CD%" "%ProgramFiles%" "%ProgramFiles(x86)%" D:\.data) DO IF EXIST "%%~fA" (
  ECHO :: Setting path from %%~fA
  CD /D "%%~fA"
  CALL :run SET _skip1=
  FOR %%B IN ("%CD%" D:\.data) DO IF "%%~A"=="%%~B" (
    CALL :run SET _skip1=TRUE
    FOR %%C IN (%PATHEXT%) DO IF EXIST "%%~fA\*%%~C" CALL :run SET _skip1=
  )
  IF NOT DEFINED _skip1 CALL :addPathList "%%~fA"
  CALL :addPathList PHP Java\jdk\jre\bin Java\jdk\bin
  CALL :addPathList Cygwin\bin 
  CALL :addPathList 7-zip WinRAR WinZip 
  CALL :addPathList Far "FAR Manager" putty DHCPSrv DOSbox WGet 
  CALL :addPathList batch compress bin exec
  FOR %%B IN (.data\.tools .tools) DO IF EXIST "%%~fA\%%~B" (
    ECHO. > nul
    CALL :addPathList "%%~fA\%%~B"
    FOR /D %%C IN ("%%~A\%%~B\*" "%%~A\%%~B\Tools\*") DO FOR %%D IN ("" "\bin") DO (
      CALL :run SET _skip2=
      FOR %%E IN (%PATHEXT%) DO IF NOT DEFINED _skip2 (
        IF EXIST "%%~fC%%~D\*%%~E" CALL :addPathList "%%~fC%%~D"
        IF EXIST "%%~fC%%~D\*%%~E" CALL :run SET _skip2=TRUE
      )
    )
  )
  CALL :addPathList Skype\Phone unlocker 
  CD /D "%_CD%\"
  ECHO :: Setting path from %%~fA: done.
  ECHO.
)

FOR /D %%A IN (%PATH% "%USERPROFILE%") DO IF EXIST "%%~fA\.antiword\" (
  CALL :run SET _path=%%~fA
  ECHO :: Setting HOME from %%~fA
  CALL :setHOME "%%~fA"
  ECHO :: Setting HOME from %%~fA: done.
  ECHO.
)

:END
CD /D "%_CD%\"
FOR %%A IN (CD path checkPath skip1 skip2) DO SET _%%~A=
GOTO :EOF

:init
ECHO :: initiation...
IF NOT DEFINED HOME CALL :setHOME "%USERPROFILE%"
SET _path=
IF NOT DEFINED PATH SET PATH=%SystemRoot%;%SystemRoot%\system32;%SystemRoot%\system32\wbem;"%ProgramFiles%";"%ProgramFiles(x86)%"
CALL :fixPathList %PATH: =/%
SET PATH=%_path%
CALL :addPathList "%ProgramFiles%" "%ProgramFiles(x86)%" "%~dp0"
ECHO :: initiation: done.
ECHO.
GOTO :EOF

:setHOME
IF "%~1"=="" GOTO :EOF
IF NOT EXIST "%~1" GOTO EOF
CALL :fullPath HOME "%~1"
SET HOME=%HOME:"=%
FOR %%A IN ("%HOME%") DO (
  SET HOMEDRIVE=%%~dA
  SET HOMEPATH=%%~pnxA
)
GOTO :EOF

:fixPathList
IF "%~1"=="" GOTO :EOF
SET _checkPath=%~1
SET _checkPath=%_checkPath:/= %
CALL :fullPath _checkPath
IF NOT "%_checkPath:"=%"=="" IF EXIST %_checkPath% CALL :addToVar _path %_checkPath%
SHIFT
GOTO :fixPathList
GOTO :EOF

:addPathList
IF "%~1"=="" GOTO :EOF
CALL :fullPath _checkPath "%~f1"
IF NOT EXIST %_checkPath% FOR /F "delims=" %%A IN ('CD') DO CALL :fullPath _checkPath "%%~fA\%~1"
IF NOT EXIST %_checkPath% CALL :fullPath _checkPath "%_CD:"=%\%~1"
IF NOT EXIST %_checkPath% GOTO :addPathList_next
FOR %%A IN (%PATH%) DO IF /I "%%~fA"=="%_checkPath:"=%" GOTO :addPathList_next
ECHO Add to path: %_checkPath%
CALL :addToVar PATH %_checkPath%
:addPathList_next
SHIFT
GOTO addPathList
GOTO :EOF

:fixPath
IF "%~1"=="" GOTO :EOF
IF NOT "%~2"=="" SET %~1=%~2
IF NOT DEFINED %~1 GOTO :EOF
CALL :run SET %~1=%%%~1:"=%%
CALL :run SET %~1=%%%~1:\\=\%%
CALL :run SET %~1=%%%~1:\\=\%%
CALL :run IF "%%%~1:~-1%%"=="\" SET %~1=%%%~1:~0,-1%%
CALL :run IF NOT "%%%~1%%"=="%%%~1: =%%" SET %~1="%%%~1%%"
GOTO :EOF

:fullPath
IF "%~1"=="" GOTO :EOF
IF NOT "%~2"=="" SET %~1=%~f2
IF NOT DEFINED %~1 GOTO :EOF
FOR /F "delims=" %%A IN ('ECHO %%%~1%%') DO SET %~1=%%~fA
CALL :fixPath %~1
GOTO :EOF

:textLenght
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
SET _textLenght=0
:textLenghtLoop
SET /A _textLenght+=1
SET %~1=%~2
CALL :run SET %~1=%%%~1:~0,%_textLenght%%%
CALL :run IF NOT "%%%~1%%"=="%~2" SET %~1=
IF NOT DEFINED %~1 GOTO textLenghtLoop
SET %~1=%_textLenght%
SET _textLenght=
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

