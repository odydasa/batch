@echo off
SET ThisFile=%~n0
SET MyCMD=FIND /i /c 

IF A%1A==AA GOTO help
IF A%2A==AA GOTO help
IF "%~f0"=="%~f1" GOTO end

SET CurFile="%~1"
SET SrcText="%~2"
SET TxtFound=%SrcText% is not found in %CurFile%
IF %CurFile%=="*" GOTO multiple
IF NOT EXIST %CurFile% ECHO GOTO nofile

FOR %%A IN (%CurFile%) DO (
  SET TxtFound=.
  %MyCMD% %SrcText% "%%~A" > nul
  IF NOT ERRORLEVEL 1 (
    ECHO   %%~A
  )
)
IF NOT "%TxtFound%"=="." ECHO %TxtFound%
goto end

:multiple
FOR /R %%A IN (*.*) DO Call %ThisFile% "%%~A" %SrcText%
goto end


:nofile
echo.
echo File not found!
echo.
goto error

:help
echo.
echo paramater format not correct
echo   %thisfile% "nama_file" "text"
echo.

:end
SET ThisFile=
SET CurFile=
