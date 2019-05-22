@ECHO OFF
SETLOCAL
CALL :init %*
CALL :help
FOR %%A IN (%_ext%) DO IF EXIST *.%%A (
  FOR /F "usebackq delims=" %%B IN (`dir "%_format%*.%%A" /b`) DO CALL :parse "%%~B"
)
IF NOT DEFINED _found ECHO Nothing's found
ENDLOCAL
GOTO :EOF

:parse
IF NOT EXIST "%~1" GOTO :EOF
SET _tmp=%~1
SET _ok=
FOR %%A IN (%_ext%) DO IF /I "%_tmp:~-3%"=="%%A" SET _ok=true
IF NOT DEFINED _ok GOTO :EOF
CALL :move "%_tmp%"
GOTO :EOF

:move
IF "%~1"=="" GOTO :EOF
IF NOT EXIST "%~1" GOTO :EOF
SET _folder=%~1
SET _folder=%_folder:~0,4%%_folder:~5,2%%_folder:~8,2%
IF NOT EXIST "%_folder%" MD "%_folder%"
>nul MOVE "%~1" %_folder%\
ECHO %~1 ==^> %_folder%\
SET _found=TRUE
GOTO :EOF

:init
SET _found=
SET _ext=JPG JPEG
SET _format=????-??-?? ??.??.??
GOTO :EOF

:help
ECHO %~n0
ECHO Move files in the current folder to specific folder based on the date 
ECHO mentioned in the file name (format: yyyy-mm-dd hh.mm.ss) 
ECHO with extension: %_ext%
ECHO.
