@ECHO OFF
CALL :init
CD /D "%CD%"
FOR %%A IN ("%CD%" "%ProgramFiles%" "%ProgramFiles(x86)%") DO IF EXISt "%%~fA" (
  CD /D "%%~fA"
  CALL :add_path "%%~fA"
  CALL :add_path PHP Java\jdk\jre\bin Java\jdk\bin Bin Compress Batch WGet Far "FAR Manager" putty Skype\Phone unlocker "C:\ProgramData\Oracle\Java\javapath"
  FOR %%B IN (.data\.tools .tools) DO IF EXIST "%%~fA\%%~B" (
    CD /D "%%~fA\%%~B"
    CALL :add_path "%%~fA\%%~B"
    FOR /D %%C IN ("%%~A\%%~B\*") DO CALL :add_path "%%~fC"
  )
  CD /D "%CD%"
)
FOR /D %%A IN (%PATH% "%USERPROFILE%") DO IF EXIST "%%~fA\.antiword\" SET HOME=%%~fA
FOR /F "delims=" %%A IN ('CD') DO SET CD=%%~A
CD /D "%CD%"
GOTO :EOF

:init
IF NOT DEFINED HOME SET HOME=%USERPROFILE%
REM SET PATH=
SET _path=
SET CD=%~dp0%
IF "%CD:~-1%"=="\" SET CD=%CD:~0,-1%
IF NOT DEFINED PATH SET PATH=%SystemRoot%;%SystemRoot%\system32;%SystemRoot%\WINDOWS;%SystemRoot%\system32\wbem;"%ProgramFiles%";"%ProgramFiles(x86)%"
FOR %%A IN (%PATH%) DO CALL :run IF EXIST "%%~A" CALL :addToVar _path %%A
SET PATH=%_path%
FOR %%A IN ("%ProgramFiles%" "%ProgramFiles(x86)%" "%CD%") DO IF EXIST "%%~fA" (
  CALL :run SET _path=%%~A
  FOR %%B IN (%PATH%) DO IF DEFINED _path IF /I "%%~A"=="%%~B" CALL :run SET _path=
  IF DEFINED _path CALL :run SET PATH=%PATH%;"%%~fA"
)
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

:addToVar
IF NOT DEFINED %1 (
  CALL :run SET %1=%2
) ELSE (
  CALL :run SET %1=%%%1%%;%2
)
GOTO :EOF

:run
%*
GOTO :EOF