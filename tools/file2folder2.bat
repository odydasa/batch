@ECHO OFF
SETLOCAL
CALL :init %*
CALL :help
FOR %%A IN (%_ext%) DO IF EXIST *.%%A (
  FOR /F "usebackq delims=" %%B IN (`dir *.%%A`) DO CALL :parse %%B
)
IF NOT DEFINED _found ECHO Nothing's found
ENDLOCAL
GOTO :EOF

:parse
SET _tmp=%*
SET _ok=
FOR %%A IN (%_ext%) DO IF /I "%_tmp:~-3%"=="%%A" SET _ok=true
IF NOT DEFINED _ok GOTO :EOF
REM FOR /F "eol= tokens=4,1 " %%A IN ("%_tmp%") DO CALL :move %%A %%B
CALL :move %_tmp:~0,10% "%_tmp:~36%"
:ECHO %*
GOTO :EOF

:move
ECHO %*
IF "%~2"=="" GOTO :EOF
IF NOT EXIST "%~2" GOTO :EOF
SET _folder=%1
SET _folder=%_folder:~6%%_folder:~3,2%%_folder:~0,2%
IF "%_folder:~0,1%"=="0" SET _folder=20%_folder%
IF "%_folder:~0,1%"=="1" SET _folder=20%_folder%
IF NOT EXIST %_folder% MD %_folder%
REM %_folder:~-2%-%_folder:~3,2%-%_folder:~0,2%
>nul MOVE %2*.* %_folder%\%_add_folder%
ECHO %~2 ==^> %_folder%\%_add_folder%
SET _found=TRUE
GOTO :EOF

:init
SET _found=
SET _pic_ext=gif jpg jpeg png
SET _mov_ext=3gp asf avi flv m4v mkv mov mp4 mpa mpe mpeg mpg ogv qt rm wmv webm
SET _aud_ext=aac aif amr m4a mp3 ogg ra wav wma
SET _ext=%_pic_ext% %_mov_ext% %_aud_ext%
IF NOT "%1"=="" FOR %%A IN (pic mov aud) DO IF /I "%1"=="%%A" (
  SET _add_folder=%%A\
  CALL :run SET _ext=%%_%%~A_ext%%
)
GOTO :EOF

:run
%*
GOTO :EOF

:help
ECHO %~n0
ECHO Move files in the current folder to specific folder based on the date 
ECHO mentioned in the file attribute (format: dd-mm-yy hh.mm filesize filename) 
ECHO with extension: %_ext%
ECHO Please set the regional format for date.
ECHO.
