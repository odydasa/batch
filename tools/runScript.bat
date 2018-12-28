@ECHO OFF
IF "%~1"=="" GOTO :EOF
SET _runScriptCurDir=%CD%
SET _runScriptRunDir=
SET _runScriptCMD=
SET _runScriptRunner=
SET _runScriptRunnerPath=
SET _runScriptEXT=%~f1
SET _runScriptValid=
SET _runScriptValidEXT=

CALL :add_runner . com exe bat cmd
CALL :add_runner WScript.exe vbs vbs js jsh wsf wsh
CALL :add_runner php.exe php php3
CALL :add_runner php-win.exe phpw
CALL :add_runner php-gtk.exe php-gtk
CALL :add_runner perl.exe pl cgi
CALL :add_runner sh.exe sh
CALL :add_runner javac.exe java
CALL :add_runner java.exe class jar

GOTO processing_ext
:add_runner_paths
CALL :add_runner_path perl.exe "%~dp0..\..\perl\bin" "%~dp0..\..\Windows\Program Files\perl\bin" "%ProgramFiles%\perl\bin"
CALL :add_runner_path php.exe "%~dp0..\..\PHP" "%~dp0..\..\Windows\Program Files\PHP" "%ProgramFiles%\PHP"
CALL :add_runner_path php-win.exe "%~dp0..\..\PHP" "%~dp0..\..\Windows\Program Files\PHP" "%ProgramFiles%\PHP"
CALL :add_runner_path php-gtk.exe "%ProgramFiles%\php-gtk2"
CALL :add_runner_path java.exe "JDKPath\jre\bin" "JDKPath\bin" "%ProgramFiles%\JDK1.5\jre\bin" "%ProgramFiles%\JDK1.5\bin"
CALL :add_runner_path javac.exe "JDKPath\bin" "%ProgramFiles%\JDK1.5\bin"

GOTO processing_cmd
:add_runner_environment
SET _runScriptRunner=
::::: --- PHP
IF /I "%_runScriptCMD%"=="php.exe" SET _runScriptRunner= -f %*

::: --- Java & Javac
IF /I "%_runScriptCMD%"=="java.exe" SET _tmpVar=java
IF /I "%_runScriptCMD%"=="javac.exe" SET _tmpVar=java
IF "%_tmpVar%"=="java" FOR /F "delims==" %%A IN ('SET JDK') DO SET %%A=
IF "%_tmpVar%"=="java" IF NOT DEFINED JDKPath FOR %%A IN ("%_runScriptRunnerPath%") DO CALL :fix_path JDKPath "%%~dpA"
IF "%_tmpVar%"=="java" FOR %%A IN ("%JDKpath%") DO IF /I "%%~nxA"=="jre" CALL :fix_path JDKPath "%%~dpA"
IF "%_tmpVar%"=="java" (
  SET JDKClass=JClass=%JDKPath%\jre\lib\charsets.jar;%JDKPath%\jre\lib\deploy.jar;%JDKPath%\jre\lib\ext\dnsns.jar;%JDKPath%\jre\lib\ext\localedata.jar;%JDKPath%\jre\lib\ext\sunjce_provider.jar;%JDKPath%\jre\lib\ext\sunpkcs11.jar;%JDKPath%\jre\lib\im\indicim.jar;%JDKPath%\jre\lib\im\thaiim.jar;%JDKPath%\jre\lib\javaws.jar;%JDKPath%\jre\lib\jce.jar;%JDKPath%\jre\lib\jsse.jar;%JDKPath%\jre\lib\plugin.jar;%JDKPath%\jre\lib\rt.jar;%JDKPath%\lib\dt.jar;%JDKPath%\lib\htmlconverter.jar;%JDKPath%\lib\jconsole.jar;%JDKPath%\lib\tools.jar
  SET JDKClassDir=%~f2
  SET JDKFile=%~n1
  IF /I "%_runScriptCMD%"=="java.exe"  SET JDKFile=%~n1
  IF /I "%_runScriptCMD%"=="javac.exe" SET JDKFile=%~nx1
  IF NOT DEFINED JDKClassDir SET JDKClassDir=%_runScriptRunDir%
)
IF "%_tmpVar%"=="java" IF NOT EXIST "%JDKClassDir%" md "%JDKClassDir%"
IF /I "%_runScriptCMD%"=="javac.exe" SET _runScriptRunner=-Xlint -sourcepath "%_runScriptRunDir%" -sourcepath "%_runScriptRunDir%" -d "%JDKClassDir%"
IF /I "%_runScriptCMD%"=="java.exe" SET _runScriptRunner=-classpath "%JDKClassDir%;%JDKClass%"
IF "%_tmpVar%"=="java" (
  SET _runScriptRunner=%_runScriptRunner% "%JDKFile%"
  IF /I "%_runScriptEXT%"=="jar" SET _runScriptRunner=%_runScriptRunner% -jar "%~1"
)
  
GOTO runScript

GOTO processing_cmd
:processing_ext
FOR %%A IN ("%_runScriptEXT%") DO SET _runScriptEXT=%~x1
IF "%_runScriptEXT:~0,1%"=="." SET _runScriptEXT=%_runScriptEXT:~1%
FOR %%A IN (%_runScriptRunner%) DO (
  CALL :check_valid_ext %%~A
  IF /I NOT "%_runScriptValid%"=="TRUE" CALL :check_runner %_runScriptEXT% %%~A
)
SET _runScriptRunner=
IF /I NOT "%_runScriptValid%"=="TRUE" SET _runScriptValid=
IF NOT DEFINED _runScriptValid GOTO error
IF NOT EXIST "%~1" GOTO nofile
FOR %%A IN ("%~1") DO CALL :fix_path _runScriptRunDir "%%~dpA"
GOTO add_runner_paths

:processing_cmd
IF "%_runScriptCMD%"=="." (
  SET _runScriptCMD=
  CALL :fix_path _runScriptRunDir "%%~dp1"
  SET _runScriptRunner=
  :processing_cmd_loop
  IF "%~1"=="" GOTO runScript
  IF DEFINED _runScriptRunner SET _runScriptRunner=%_runScriptRunner% "%~1"
  IF NOT DEFINED _runScriptRunner SET _runScriptRunner="%~1"
  SHIFT
  GOTO runScript
)
IF DEFINED _runScriptCMD (
  IF NOT EXIST "%_runScriptCMD%" FOR %%A IN ("%_runScriptCMD%") DO (
    IF NOT EXIST "%_runScriptCMD%" IF NOT "%%~f$PATH:A"=="" (
      IF EXIST "%%~f$PATH:A" SET _runScriptCMD=%%~f$PATH:A
    )
  )
  IF NOT EXIST "%_runScriptCMD%" FOR %%A IN ("%_runScriptCMD%") DO (
    IF NOT EXIST "%_runScriptCMD%" IF NOT "%%~f$_runScriptRunnerPath:A"=="" (
      IF EXIST "%%~f$_runScriptRunnerPath:A" SET _runScriptCMD=%%~f$PATH:A
    )
  )
  IF NOT EXIST "%_runScriptCMD%" FOR %%A IN (%_runScriptRunnerPath%) DO (
    IF NOT EXIST "%_runScriptCMD%" IF EXIST "%%~A\%_runScriptCMD%" ( 
      SET _phpCMD=%%~fA\%_runScriptCMD%
    )
  )
)
IF /I "%_runScriptValid%"=="TRUE" IF DEFINED _runScriptCMD IF NOT EXIST "%_runScriptCMD%" GOTO error
IF EXIST "%_runScriptCMD%" (
  FOR %%A IN ("%_runScriptCMD%") DO (
    SET _runScriptCMD=%%~nxA
    CALL :fix_path _runScriptRunnerPath "%%~dpA"
  )
)
GOTO add_runner_environment

:add_runner
IF "%~1"=="" GOTO :EOF
IF DEFINED _runScriptRunner SET _runScriptRunner=%_runScriptRunner% "%*"
IF NOT DEFINED _runScriptRunner SET _runScriptRunner="%*"
GOTO :EOF

:add_runner_path
IF "%~1"=="" GOTO :EOF
IF NOT DEFINED _runScriptCMD GOTO :EOF
IF /I NOT "%_runScriptCMD%"=="%~1" GOTO :EOF
:add_runner_path_loop
IF "%~2"=="" GOTO :EOF
IF DEFINED _runScriptRunnerPath SET _runScriptRunnerPath=%_runScriptRunnerPath%;%2
IF NOT DEFINED _runScriptRunnerPath SET _runScriptRunnerPath=%2
SHIFT/2
GOTO add_runner_path_loop
GOTO :EOF

:check_runner
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
:check_runner
IF "%~3"=="" GOTO :EOF
IF "%~1"=="%~3" (
  SET _runScriptValid=TRUE
  SET _runScriptCMD=%~2
  GOTO :EOF
)
SHIFT/3
GOTO check_runner
GOTO :EOF

:add_valid_ext
IF "%~1"=="" GOTO :EOF
:check_valid_ext
IF "%~2"=="" GOTO :EOF
IF DEFINED _runScriptValidEXT SET _runScriptValidEXT=%_runScriptValidEXT% %~2
IF NOT DEFINED _runScriptValidEXT SET _runScriptValidEXT=%~2
SHIFT/2
GOTO check_valid_ext
GOTO :EOF

:fix_path
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
SET _tmpPath=%~2
IF "%_tmpPath:~-1%"=="\" SET %~1=%_tmpPath:~0,-1%
SET _tmpPath=
GOTO :EOF


:nofile
ECHO.
ECHO File not found!
ECHO.
GOTO help

:error
ECHO.
ECHO System engine error/ not found!
ECHO No runner for current extension: %_runScriptEXT%
ECHO.
GOTO help

:help
ECHO Usage:
ECHO   %~n0 ScriptFile
ECHO   %~n0 ExecutableFile
ECHO.
ECHO Run command/ script, based on given script extension
ECHO Currently valid extension(s):
ECHO   [%_runScriptValidEXT%]
ECHO.
GOTO end


:runScript
IF DEFINED _runScriptCMD IF NOT DEFINED _runScriptRunner SET _runScriptRunner=%*
IF DEFINED _runScriptRunnerPath IF DEFINED _runScriptCMD SET _runScriptCMD="%_runScriptRunnerPath%\%_runScriptCMD%" %_runScriptRunner%
IF NOT DEFINED _runScriptCMD SET _runScriptCMD=%_runScriptRunner%
CD /D "%_runScriptRunDir%"
ECHO %_runScriptCMD%
CD /D "%_runScriptCurDir%"
GOTO end


:end
REM SET _runScript
FOR %%A IN (ThisFile varOK tmpVar) DO @SET _%%A=
FOR /F "delims==" %%A IN ('SET _runScript') DO SET %%A=
pause
GOTO :EOF
