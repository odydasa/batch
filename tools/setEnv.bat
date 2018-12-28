@ECHO OFF
CALL :init
CD /D "%CD%"
CALL :add_path "C:\ProgramData\Oracle\Java\javapath" 
FOR %%A IN ("%CD%" "%ProgramFiles%" "%ProgramFiles(x86)%" D:\.data) DO IF EXIST "%%~fA" (
  CD /D "%%~fA"
  CALL :add_path "%%~fA"
  CALL :add_path PHP Java\jdk\jre\bin Java\jdk\bin
  CALL :add_path Cygwin\bin 
  CALL :add_path Bin Compress Batch WGet Far "FAR Manager" putty 
  CALL :add_path Skype\Phone unlocker 
  FOR %%B IN (.data\.tools .tools) DO IF EXIST "%%~fA\%%~B" (
    CD /D "%%~fA\%%~B"
    CALL :add_path "%%~fA\%%~B"
    FOR /D %%C IN ("%%~A\%%~B\*") DO CALL :add_path "%%~fC"
  )
  CD /D "%CD%"
)
FOR /D %%A IN (%PATH% "%USERPROFILE%") DO IF EXIST "%%~fA\.antiword\" (
  CALL :fullPath HOME "%%~fA"
)
FOR /F "delims=" %%A IN ('CD') DO SET CD=%%~A
CD /D "%CD%"
GOTO :EOF

:init
IF NOT DEFINED HOME SET HOME=%USERPROFILE%
REM SET PATH=
SET _path=
CALL :fullPath CD "%~dp0%"
IF NOT DEFINED PATH SET PATH=%SystemRoot%;%SystemRoot%\system32;%SystemRoot%\WINDOWS;%SystemRoot%\system32\wbem;"%ProgramFiles%";"%ProgramFiles(x86)%"
CALL :defPath %PATH: =##%
SET PATH=%_path%
FOR %%A IN ("%ProgramFiles%" "%ProgramFiles(x86)%" "%CD%") DO IF EXIST "%%~fA" (
  CALL :run SET _path=%%~A
  FOR %%B IN (%PATH%) DO IF DEFINED _path IF /I "%%~A"=="%%~B" CALL :run SET _path=
  IF DEFINED _path CALL :run SET PATH=%PATH%;"%%~fA"
)
GOTO :EOF

:defPath
IF "%~1"=="" GOTO :EOF
SET _xPath=%~1
SET _xPath=%_xPath:##= %
IF "%_xPath:~-1%"=="\" SET _xPath=%_xPath:~0,-1%
FOR %%A IN (%_path%) DO IF /I "%%~A"=="%_xPath%" SET _xPath=
IF NOT "%_xPath%"=="" IF EXIST "%_xPath%" CALL :addToVar _path "%_xPath%"
SHIFT
GOTO :defPath
GOTO :EOF

:add_path
IF "%~1"=="" GOTO :EOF
SET _path=%~f1
IF NOT EXIST "%_path%" FOR /F "delims=" %%A IN ('CD') DO SET _path=%%~fA\%~1
IF NOT EXIST "%_path%" SET _path=%CD%\%~1
IF NOT EXIST "%_path%" GOTO next
FOR %%A IN (%PATH%) DO IF /I "%%~fA"=="%_path%" GOTO next
ECHO Add to path: %_path%
CALL :addToVar PATH "%_path%"
:next
SHIFT
GOTO add_path

:fixPath
IF "%~1"=="" GOTO :EOF
IF NOT "%~2"=="" SET %~1=%~2
IF NOT DEFINED %~1 GOTO :EOF
CALL CALL :run IF "%%%%%~1:~-1%%%%"=="\" SET %~1=%%%%%~1:~0,-1%%%%
CALL CALL :run IF "%%%%%~1:~-1%%%%"=="\" CALL :fixPath %~1
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

