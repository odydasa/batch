@ECHO OFF
SET _Folder2DesktopINI_target=%~1
IF NOT DEFINED _Folder2DesktopINI_target SET _Folder2DesktopINI_target=.
FOR %%A IN ("%_Folder2DesktopINI_target%") DO (
  SET _Folder2DesktopINI_target=%%~fA
  SET _Folder2DesktopINI_icon=%%~nxA
)
IF "%_Folder2DesktopINI_target:~-1%"=="\" (
  SET _Folder2DesktopINI_target=%_Folder2DesktopINI_target:~0,-1%
)
IF NOT "%~2"=="" IF EXIST "%~2" SET _Folder2DesktopINI_icon=%~2
IF NOT EXIST "%_Folder2DesktopINI_target%\%_Folder2DesktopINI_icon%" (
  FOR %%A IN (ico exe) DO (
    IF EXIST "%_Folder2DesktopINI_target%\%_Folder2DesktopINI_icon%.%%A" (
      SET _Folder2DesktopINI_icon=%_Folder2DesktopINI_icon%.%%A
      GOTO next1
    )
  )
)

:next1
IF EXIST "%_Folder2DesktopINI_target%\%_Folder2DesktopINI_icon%" (
  ATTRIB +s "%_Folder2DesktopINI_target%"
  CALL :make_dekstop "%_Folder2DesktopINI_target%" "%_Folder2DesktopINI_icon%"
)
GOTO end

:make_dekstop
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
IF EXIST "%~1\desktop.ini" (
  ATTRIB -a -r -s -h "%~1\desktop.ini"
  DEL /F /Q "%~1\desktop.ini"
)
CALL :gen_desktop_ini "%~2" > "%~1\desktop.ini"
:TYPE "%~1\desktop.ini"
ATTRIB -a -r +s +h "%~1\desktop.ini"
GOTO :EOF

:gen_desktop_ini
ECHO [.ShellClassInfo]
ECHO IconFile=%~1%
ECHO IconIndex=0
GOTO :EOF

:end
FOR /F "delims==" %%A IN ('SET _Folder2DesktopINI') DO SET _%%~A=
GOTO :EOF
