@ECHO OFF
IF "%~1"=="" GOTO help
IF NOT "%~2"=="" GOTO SetVar
SETLOCAL
FOR /F "usebackq delims=" %%A IN (`ECHO "%~1"`) DO (
  IF NOT "%%~xA"=="" (
    SET AppList=%%~A
  ) ELSE (
    CALL :AddList "%%~A" %PATHEXT%
  )
)
FOR %%A IN (%AppList%) DO IF NOT EXIST "%FullPath%" FOR %%B IN (%PATH%) DO IF NOT EXIST "%FullPath%" (
  IF EXIST "%%~B\%%~A" SET FullPath=%%~B\%%~A
  REM ECHO %%~B\%%~A
)
FOR %%A IN (%AppList%) DO IF NOT EXIST "%FullPath%" FOR /F "usebackq delims=" %%B IN (`DIR /ad /b /on "%PROGRAMFILES%"`) DO IF NOT EXIST "%FullPath%" (
  IF EXIST "%PROGRAMFILES%\%%~B\%%~A" SET FullPath=%PROGRAMFILES%\%%~B\%%~A
  REM ECHO %PROGRAMFILES%\%%~B\%%~A
)
ECHO "%FullPath%"
GOTO end

:AddList
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
IF DEFINED AppList SET AppList=%AppList%;"%~1%~2"
IF NOT DEFINED AppList SET AppList="%~1%~2"
SHIFT /2
GOTO AddList
GOTO :EOF

:SetVar
FOR %%A IN (SET RUN) DO IF /I "%%~A"=="%~2" (
  IF /I "%~2"=="SET" IF "%~3"=="" GOTO help
  FOR /F "usebackq delims=" %%A IN (`CALL "%~f0" "%~1"`) DO (
  IF /I "%~2"=="SET" SET %~3=%%~A
  IF /I "%~2"=="RUN" "%%~A" %3 %4 %5 %6 %7 %8 %9
  )
)
GOTO :EOF

:help
GOTO :EOF

:end
ENDLOCAL
