@ECHO Off
SET _MakeFolder_AutorunFile=autorun.inf
SET _MakeFolder_DesktopFile=desktop.ini
SET _MakeFolder_ReplaceCmd="%~dp0ContentReplace"
SET _MakeFolder_BaseDir=%~1
SET _MakeFolder_Icon=##SystemRoot##\system32\SHELL32.dll

IF NOT DEFINED _MakeFolder_BaseDir SET _MakeFolder_BaseDir=.\
FOR %%A IN ("%_MakeFolder_BaseDir%") DO SET _MakeFolder_BaseDir=%%~fA
IF "%_MakeFolder_BaseDir:~-1%"=="\" SET _MakeFolder_BaseDir=%_MakeFolder_BaseDir:~0,-1%

ECHO Set folders and setting....
ECHO Base directory: %_MakeFolder_BaseDir%
CALL :fix_drive                   ".tools\PStart\PStart.exe" 0
CALL :fix_folder ".data"          "%_MakeFolder_Icon%" 171
CALL :fix_folder ".data\.bin"     "%_MakeFolder_Icon%" 20
CALL :fix_folder ".data\.install" "%_MakeFolder_Icon%" 15
CALL :fix_folder ".data\.tmp"     "%_MakeFolder_Icon%" 31
CALL :fix_folder ".tools"         "%_MakeFolder_Icon%" 20
CALL :fix_folder " error"         "%_MakeFolder_Icon%" 47
CALL :fix_folder "_backup"        "%SystemRoot%\system32\zipfldr.dll" 0

CALL :make_sub ".data\.doc";""   ### notes;"" pages;"" themes;"" web;""
CALL :make_sub ".data\.mmda";130 ### MIDI;116 "My Music";-237 "My Pictures";141 "My Video";-238
CALL :make_sub ".data\.NET";13   ### Data;"" Download;"" Mail;"" Temp;"" Web;""

GOTO end

:make_sub
IF "%~1"=="" GOTO :EOF
CALL :fix_folder "%~1" "%_MakeFolder_Icon%" "%~2"
:make_sub_loop
IF "%~4*"=="*" GOTO make_sub_next
CALL :fix_folder "%~1\%~4" "%_MakeFolder_Icon%" "%~5"
SHIFT /3
SHIFT /3
GOTO make_sub_loop
:make_sub_next
GOTO :EOF

:fix_drive
CALL :fix_folder . %* > nul
IF "%~1*"=="*" GOTO :EOF
IF "%~2*"=="*" GOTO :EOF
CALL :make_autorun .\ %*
GOTO :EOF

:fix_folder
IF "%~1*"=="*" GOTO :EOF
ECHO %~1\
CALL :make_folder    "%_MakeFolder_BaseDir%\%~1"
CALL :attrib dir set "%_MakeFolder_BaseDir%\%~1"
IF "%~2*"=="*" GOTO :EOF
IF "%~3*"=="*" GOTO :EOF
CALL :make_desktop_ini %*
GOTO :EOF

:make_autorun
SET _tmpAutorun="%_MakeFolder_BaseDir%\%_MakeFolder_AutorunFile%"
CALL :remove_file     %_tmpAutorun%
CALL :gen_autorun     %* > %_tmpAutorun%
CALL :fix_ini_file    %_tmpAutorun%
CALL :attrib file set %_tmpAutorun%
SET _tmpAutorun=
GOTO :EOF

:make_desktop_ini
SET _tmpDesktop="%_MakeFolder_BaseDir%\%~1\%_MakeFolder_DesktopFile%"
CALL :remove_file     %_tmpDesktop%
CALL :gen_desktop_ini %* > %_tmpDesktop%
CALL :fix_ini_file    %_tmpDesktop%
CALL :attrib file set %_tmpDesktop%
SET _tmpDesktop=
GOTO :EOF

:gen_autorun
@ECHO OFF
ECHO [AutoRun]
ECHO Icon=%~2,%~3
FOR %%A IN (%4 %5 %6 %7 %8 %9) DO @ECHO %%~A
ECHO.
GOTO :EOF

:gen_desktop_ini
@ECHO OFF
ECHO [.ShellClassInfo]
ECHO IconFile=%~2
ECHO IconIndex=%~3
FOR %%A IN (%4 %5 %6 %7 %8 %9) DO @ECHO %%~A
ECHO.
GOTO :EOF

:fix_ini_file
IF NOT EXIST "%~1" GOTO :EOF
CALL %_MakeFolder_ReplaceCmd% "%~1" "##" "chr(37)" >nul
GOTO :EOF

:attrib
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
IF /I NOT "%~1"=="dir" IF /I NOT "%~1"=="file"  GOTO :EOF
IF /I NOT "%~2"=="set" IF /I NOT "%~2"=="reset" GOTO :EOF
IF NOT EXIST "%~3" GOTO :EOF
IF /I "%~2"=="set" (
  IF /I "%~1"=="dir"  attrib -a -r -h +s "%~3" %~4 %~5
  IF /I "%~1"=="file" attrib -a -r +h +s "%~3" %~4 %~5
)
IF /I "%~2"=="reset"  attrib -a -r -h -s "%~3" %~4 %~5
GOTO :EOF

:make_folder
IF "%~1*"=="*" GOTO :EOF
IF EXIST "%~f1" GOTO :EOF
MD "%~f1"
GOTO :EOF

:remove_file
IF NOT EXIST "%~f1" GOTO :EOF
CALL :attrib file reset "%~f1"
DEL /F /Q "%~f1"
GOTO :EOF

:help
ECHO Error! 
ECHO parameter used: %*
ECHO.
ECHO Using:
ECHO   %~n0 [drive]
ECHO.
GOTO end

:end
FOR /F "delims==" %%A IN ('SET _MakeFolder') DO SET %%~A=
ECHO Done...
ECHO Thank you.
ECHO.
