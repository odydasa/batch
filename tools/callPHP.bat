@ECHO OFF
SET _phpCMD=php.exe
SET _phpPath=

CALL :add_php_path "%~dp0..\..\PHP"
CALL :add_php_path "%~dp0..\..\Windows\Program Files\PHP" 
CALL :add_php_path "%ProgramFiles%\PHP"

IF NOT EXIST "%_phpCMD%" FOR %%A IN ("%_phpCMD%") DO (
  IF NOT EXIST "%_phpCMD%" IF NOT "%%~f$PATH:A"=="" (
    IF EXIST "%%~f$PATH:A" SET _phpCMD=%%~f$PATH:A
  )
)
IF NOT EXIST "%_phpCMD%" FOR %%A IN ("%_phpCMD%") DO (
  IF NOT EXIST "%_phpCMD%" IF NOT "%%~f$SHAREDPROGRAMS:A"=="" (
    IF EXIST "%%~f$SHAREDPROGRAMS:A" SET _phpCMD=%%~f$PATH:A
  )
)
IF NOT EXIST "%_phpCMD%" FOR %%A IN (%_phpPath%) DO (
  IF NOT EXIST "%_phpCMD%" IF EXIST "%%~A\%_phpCMD%" ( 
    SET _phpCMD=%%~fA\%_phpCMD%
  )
)
IF NOT EXIST "%_phpCMD%" (GOTO error) ELSE (
  FOR %%A IN ("%_phpCMD%") DO SET _phpCMD=%%~fsA
)
"%_phpCMD%" %*
GOTO end

:add_php_path
IF "%~1"=="" GOTO :EOF
IF NOT EXIST "%~f1" GOTO :EOF
IF NOT DEFINED _phpPath SET _phpPath="%~f1"
IF DEFINED _phpPath FOR %%A IN (%_phpPath%) DO (
  IF /I "%%~fA"=="%~f1" GOTO :EOF
  SET _phpPath=%_phpPath%;"%~f1"
)
GOTO :EOF

:error
ECHO.
ECHO System engine error/ not found!
ECHO.
GOTO end

:end
FOR %%A IN (phpCMD phpPath) DO SET _%%~A=
GOTO :EOF
