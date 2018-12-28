@ECHO OFF
SETLOCAL
FOR /F "delims=" %%A IN ('CD') DO SET CD=%%~A
IF "%~1"=="" GOTO end
CALL :setDir _target "%~1"
SET _op=/S
IF EXIST "%~1\" SET _op=/D
IF NOT "%~2"=="" (CALL :setDir _link "%~2") ELSE (
  FOR %%A IN (.\) DO IF "%~dp1"=="%%~fA\" GOTO end
)

FOR %%A IN ("%_target%") DO FOR %%B IN ("%_link%") DO IF "%%~dA"=="%%~dB" (
  SET _target=%%~fA
  SET _link=%%~fB
)
FOR %%A IN ("%_target%") DO FOR %%B IN ("%_link%") DO IF "%%~dA"=="%%~dB" (
  CALL :relativePath "%_target%" "%_link%"
)
FOR %%A IN ("%_target%") DO SET _link=%_link%\%%~nxA
FOR %%A IN (_target _link) DO CALL :run SET %%A=%%%%A:\\=\%%
ECHO mklink %_op% "%_link%" "%_target%"
mklink %_op% "%_link%" "%_target%"

:end
ENDLOCAL
GOTO :EOF

:compareDir
IF "%~1"=="" GOTO :EOF
SET _dirX=%_dirBase%
SET _dirBase=%_dirBase%\%~1
CALL :run IF "%%_dir2:%_dirBase%=%%"=="%%_dir2%%" SET _dirFound=TRUE
IF DEFINED _dirFound (
  SET _dirBase=%_dirX%\
  SET _dirX=
  SET _dirFound=
  GOTO :EOF
)
SHIFT
GOTO compareDir

:relativePath
SET _dir1=%~1
SET _dir2=%~2
SET _dirBase=%~d1
SET _dirFound=
REM SET _dir
SET _dirX=%_dir1:~3%
CALL :compareDir "%_dirX:\=" "%"
CALL :run SET _dir1=%%_dir1:%_dirBase%=%%
CALL :run SET _dir2=%%_dir2:%_dirBase%=%%
SET _dirX=
FOR %%A IN ("%_dir2:\=";"%") DO CALL :run SET _dirX=%%_dirX%%..\
SET _target=%_dirX%%_dir1%
SET _link=%_dirBase%\%_dir2%
:FOR /F "delims==" %%A IN ('SET _dir') DO SET %%A=
FOR %%A IN (1 2 Base) DO SET _dir%%~A=
REM SET _dir
GOTO :EOF


:fixDir
IF "%~1"=="" GOTO :EOF
IF NOT DEFINED %~1 GOTO :EOF
CALL :run IF "%%%~1:~-1%%"=="\" SET %~1=%%%~1:~0,-1%%
GOTO :EOF

:fixDirs
FOR %%A IN (_dirBase _dir1 _dir2) DO IF DEFINED %%~A CALL :fixDir %%~A
GOTO :EOF

:setDir
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
SET %~1=%~2
CALL :fixDir %~1
GOTO :EOF

:run
%*
GOTO :EOF