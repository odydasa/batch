@ECHO OFF
SET __envvar_runable="%~dp0%~n0SET%~x0"
SET __envvar_val=%*
IF /I "%~1"=="SET" IF NOT "%~2"=="" GOTO :set
IF /I "%~1"=="RUN" IF NOT "%~2"=="" GOTO :run
CALL :clear_var
GOTO :EOF

:set

:: Check whenever format not "SET var_name=value"
SET __envvar_var1=%__envvar_val:~4%
SET __envvar_var1=%__envvar_var1:"=%
SET __envvar_var1=%__envvar_var1:'=%
SET __envvar_var1=%__envvar_var1:`=%
FOR /F "delims= " %%A IN ("%__envvar_var1%") DO (
  SET __envvar_var2=%%A
  FOR /F "delims==" %%B IN ("%%~A") DO SET __envvar_var1=%%B
)
IF "%__envvar_var2%"=="%__envvar_var1%" GOTO error

:: Check whenever value is command
FOR /F "tokens=1,2* delims==" %%A IN ("%__envvar_val:~4%") DO SET __envvar_var1=%%B%%C
SET __envvar_var1=%__envvar_var1:`=ç%
SET __envvar_var2=FALSE
IF "%__envvar_var1:~0,1%"=="ç" IF NOT "%__envvar_var1:~-1%"=="ç" (GOTO error) ELSE SET __envvar_var2=TRUE
IF /I "%__envvar_var2%"=="TRUE" SET __envvar_var1=%__envvar_var1:~1,-1%
SET __envvar_var3=%__envvar_var1:"="%
IF NOT "%__envvar_var3%"=="%__envvar_var3:ç=%" GOTO error 
FOR /F "delims==" %%A IN ("%__envvar_val:~4%") DO SET __envvar_name=%%A
SET __envvar_val=%__envvar_var1%
SET __envvar_var1=%__envvar_var2%
SET __envvar_var2=
SET __envvar_var3=


:: generate runable
IF /I "%__envvar_var1%"=="TRUE" (
  %__envvar_val%>%__envvar_runable%
  FOR /F "delims=" %%A IN ('TYPE %__envvar_runable%') DO SET __envvar_val=%%A
)
>%__envvar_runable%  ECHO SET %__envvar_name%=%__envvar_val%
>>%__envvar_runable% ECHO REM SET %__envvar_name%
>>%__envvar_runable% ECHO "%~f0" RUN %__envvar_val:~4%
REM TYPE %__envvar_runable%
%__envvar_runable%
GOTO end

:run
REM FOR /F "usebackq tokens=1* delims= " %%A IN (`ECHO %__envvar_val:~4%`) DO IF DEFINED %%A SET %%A
REM FOR %%A IN (%__envvar_runable%) DO ECHO %%~zA
GOTO end

:error
ECHO Error!
ECHO %*
GOTO :EOF

:clear_var
IF DEFINED __envvar_runable IF EXIST "%__envvar_runable:"=%" DEL /F /Q "%__envvar_runable:"=%"
FOR %%A IN (var_cmd var_opt) DO SET __%%~A=
GOTO :EOF

:end
CALL :clear_var
GOTO :EOF
