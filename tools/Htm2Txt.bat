@echo off
SET _validParam=--dump
SET _htmlDump=html_dump.bat

SET _thisFile=%~n0
SET _myCMD=PHP -f "%~dp0%~n0.php"
SET _tmpList=%tmp%\~$htm2txt_temp%RANDOM%%RANDOM%%RANDOM%.lst
SET _tmpFile_htm2txt=%tmp%\~$htm2txt_temp%RANDOM%%RANDOM%%RANDOM%.htm
SET _htmlDump=%~dp0\%_htmlDump%
IF "%1"=="" GOTO help
IF NOT "%2"=="" IF NOT "%2"=="%_validParam%" GOTO help
IF "%~f0"=="%~f1" GOTO help

CALL :del_file "%_tmpList%"
CALL :listOK FALSE

FOR %%A IN (%1) DO ECHO %%~A >> "%_tmpList%"
IF NOT EXIST "%_tmpList%" GOTO help
FOR /F "usebackq delims=" %%A IN (`TYPE "%_tmpList%"`) DO (
  CALL :listOK TRUE
  %_myCMD% %_htmlDump% %%~fsA > %_tmpFile_htm2txt%
  IF "%2"=="%_validParam%" (
    TYPE %_tmpFile_htm2txt%
  ) ELSE (
    ECHO %%~A
    TYPE %_tmpFile_htm2txt% > "%%~fA.txt"
  )

)
IF NOT "%_listOK%"=="TRUE" GOTO nofile
GOTO end

:listOK
SET _listOK=%1
GOTO :EOF

:del_file
IF NOT EXIST "%~1" GOTO :EOF
DEL /F /Q "%~1"
GOTO :EOF

:nofile
echo.
echo File not found!
echo.
goto error

:help
echo.
echo paramater format not correct
echo   %_thisFile% "nama_file" [%_validParam%]
echo.

:end
CALL :del_file "%_tmpList%"
CALL :del_file "%_tmpFile_htm2txt%"
FOR %%A IN (validParam thisFile myCMD htmlDump tmpList listOK) DO SET _%%A=
