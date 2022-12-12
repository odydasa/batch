@ECHO OFF
SETLOCAL
SET _folder=update
SET _html=%tmp%\far_web
SET _links=%tmp%\far_links

SET _FARWeb=https://farmanager.com/download.php?l=en
SET _FARURL=https://farmanager.com/

SET _getWeb=wget -q --no-check-certificate -O "%_html%" %_FARWeb%
SET _getLinks=sed -n 's/.*href="\([^"]*\).*/\1/p' "%_html%"
SET _getMSI=wget -q --no-check-certificate --show-progress -O "##MSI_file##" ##MSI_link##

ECHO Updating FAR Manager
ECHO   [] Get links from %_FARWeb%
%_getWeb% > nul

ECHO   [] Get setup file link
%_getLinks% | grep ".msi" > "%_links%"
FOR /F "usebackq delims=" %%A IN (`TYPE "%_links%"`) DO (
  SET _FARURL=%_FARURL%/%%~A
  ECHO      %_FARURL%/%%~A
  CALL :getMSI %%~A
  GOTO next
)
:next
ECHO   [] Run setup
ECHO      %_FARSetup%
FOR /F "usebackq delims=" %%A IN (`dir /b %~dp0*.exe`) DO (
  taskkill /F /T /im %%~nxA > nul
)
msiexec /i "%_FARSetup%" /passive
ECHO.
ECHO Done.
ECHO.
GOTO :EOF

:getMSI
SET _x=%_getMSI%
SET _FARURL=%_FARURL:.com//=.com/%
FOR /F "delims=" %%A IN ('ECHO %*') DO SET _FARSetup=%~dp0%_folder%\%%~nxA
CALL :run SET _getMSI=%%_getMSI:##MSI_file##=%_FARSetup%%%
CALL :run SET _getMSI=%%_getMSI:##MSI_link##=%_FARURL%%%
ECHO   [] Get setup file
%_getMSI%
ECHO.
ECHO      %_FARSetup%
GOTO :EOF

:run
%*
GOTO :EOF