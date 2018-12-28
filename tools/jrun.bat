@ECHO OFF
IF A%1A==AA GOTO help
CALL :clear_vars
IF NOT DEFINED JDKPath SET JDKPath=D:\.data\apps\jdk1.5
SET JClass=%JDKPath%\jre\lib\charsets.jar;%JDKPath%\jre\lib\deploy.jar;%JDKPath%\jre\lib\ext\dnsns.jar;%JDKPath%\jre\lib\ext\localedata.jar;%JDKPath%\jre\lib\ext\sunjce_provider.jar;%JDKPath%\jre\lib\ext\sunpkcs11.jar;%JDKPath%\jre\lib\im\indicim.jar;%JDKPath%\jre\lib\im\thaiim.jar;%JDKPath%\jre\lib\javaws.jar;%JDKPath%\jre\lib\jce.jar;%JDKPath%\jre\lib\jsse.jar;%JDKPath%\jre\lib\plugin.jar;%JDKPath%\jre\lib\rt.jar;%JDKPath%\lib\dt.jar;%JDKPath%\lib\htmlconverter.jar;%JDKPath%\lib\jconsole.jar;%JDKPath%\lib\tools.jar
SET JFile=%~n1.java
SET JLoc=.\
IF NOT EXIST "%JFile%" GOTO nofile
IF A%2A==AA GOTO RunJava


SET JavacParam=-Xlint -sourcepath %JLoc%
SET JavacParam=-sourcepath %JLoc%
SET ClassDir=%~2
IF NOT EXIST "%ClassDir%" md "%ClassDir%" >nul
SET JavacParam=%JavacParam% -d "%ClassDir%"
GOTO RunJava

:RunJava
SET ClassDir=.\
IF NOT "%2"*==""* (SET ClassDir=%~f2)
SET JavaParam=-classpath "%ClassDir%;%JClass%"
CALL :run_program "%JDKPath%\bin\javac" %JavacParam% "%JFile%"
CALL :run_program "%JDKPath%\jre\bin\java" %JavaParam% %~n1
CALL :run_program Beep
GOTO end

:nofile
ECHO.
ECHO Class: "%~n1" is not existing.
ECHO   or   "%JFile%" file is not existing
ECHO File: "%JFile%" is not existing.
ECHO.
GOTO help

:help
ECHO.
ECHO Usage: JRun class [ClassPath]
ECHO    or  JRun javafile  [ClassPath]
ECHO.
REM ECHO Option:
REM ECHO   -v   Verbose
REM ECHO.
GOTO end

:run_program
:ECHO %*
CALL %*
GOTO :EOF

:clear_vars
FOR %%A IN (JDKPath JClass JFile ClassDir JavacParam JavaParam) DO @SET %%A=
GOTO :EOF

:end
CALL :clear_vars
