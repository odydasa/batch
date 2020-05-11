@ECHO OFF
SETLOCAL
CALL :init %*
CALL :help

CALL :mainLoop %_EXTtype%

IF NOT DEFINED _found ECHO Nothing's found
ENDLOCAL
GOTO :EOF

:mainLoop
IF "%~1"=="" GOTO :EOF
CALL :run SET _ext=%%_%~1_ext%%
FOR %%A IN (%_ext%) DO IF EXIST *.%%A (
 FOR %%B IN (*.%%A) DO CALL :parse "%~1" "%%~tB" "%%~B" 
)
SHIFT
GOTO mainLoop
GOTO :EOF

:parse
IF "%~3"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
IF "%~1"=="" GOTO :EOF
FOR %%A IN (Date Folder) DO SET _f%%~A=
SET _fDate=%~2
SET _fDate=%_fDate:~6,4%%_fDate:~3,2%%_fDate:~0,2%
SET _fFolder=%~1\%_fDate:~0,4%\%_fDate:~4,2%\%_fDate%
FOR %%A IN ("%~3") DO (
  ECHO   [] %_fFolder%: %%~A
  IF NOT EXIST "%_fFolder%\" MD "%_fFolder%\"
  MOVE /Y "%%~A" "%_fFolder%" > nul
  SET _found=TRUE
)

FOR %%A IN (Date Folder) DO SET _f%%~A=
GOTO :EOF


:init
SET _found=
SET _AUD_ext=aac aif amr m4a mp3 mpa ogg ra ram wav wma 
SET _BIN_ext=apk bat bin deb dll exe msi msu 
SET _DOC_ext=doc docx dot dotx pdf pps ppt pptx rtf txt xls xlsx xlt xltx
SET _DSG_ext=cdr psd
SET _ENG_ext=kml kmz
SET _IMG_ext=bmp gif jpg jpeg png tif
SET _VID_ext=3gp asf avi flv m4v mkv mov mp4 mpa mpe mpeg mpg ogv qt rm wmv webm
SET _ZIP_ext=7z ace arj bz2 gz gzip img iso lzh r0* r1* rar sea sit sitx tar z zip

SET _EXTtype=AUD BIN DOC DSG ENG IMG VID ZIP
IF NOT "%1"=="" FOR %%A IN (%_EXTtype%) DO IF /I "%1"=="%%A" SET _EXTtype=%%~A
SET _ext=
GOTO :EOF



:run
%*
GOTO :EOF

:help
ECHO %~n0
ECHO Move files in the current folder to specific folder based on the date 
ECHO of the file's attribute (format: dd/mm/yy hh:mm) 
ECHO from extensions: 
FOR %%A IN (%_EXTtype%) DO (
  CALL :run ECHO - %%A: %%_%%~A_ext%%
)
ECHO.
