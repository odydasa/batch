@echo off
SET Var1=
SET MyCMD=PHP -f "%~dp0TConv.php"
SET Var1=\n\r
SET FileList=
IF A%1A==AA GOTO help
IF NOT A%1A==AA (
  FOR %%A IN (-h -help) DO IF /I %%A==%1 GOTO help
  IF /I NOT %1==-d IF /I NOT %1==-u  SET FileList="%~1"
  IF /I %1==-d IF NOT A%2A==AA SET FileList="%~2"
  IF /I %1==-u IF NOT A%2A==AA SET FileList="%~2"
)
IF A%FileList%A==AA GOTO help

FOR %%A in (%FileList%) DO @(
  IF NOT EXIST "%%~fA" @(
    CALL :nofile "%%~fA" 
    GOTO help
  )
  %MyCMD% "%Var1%" "%%~fA"
)
goto end

:nofile
ECHO.
ECHO File(s) not existing: %1
GOTO :EOF

:help
ECHO.
ECHO Usage: %thisfile% [option] file_list
ECHO.
ECHO   Option:
ECHO     -d     Output will be in DOS format
ECHO     -u     Output will be in UNIX format
ECHO.
GOTO end

:end
FOR %%A in (Var1 MyCMD FileList) DO SET %%A=

