@ECHO OFF
SET _comma=.
SET _comma=%_comma:.=,%

SET _test1=%~1
FOR /F "usebackq delims=" %%A IN (`ECHO SET _test1="%%%%_test1:%2%_comma%%3%%%%"`) DO CALL :test %%A

SET _
FOR /F "usebackq delims==" %%A IN (`SET _`) DO SET %%A=
GOTO :EOF
FOR /F "eol=# tokens=1,3* delims=" %%A IN (mime.types) DO (
  CALL :print %%A %%B %%C
)
SET _ext=%_ext:html.var=html.var.*%
SET _
GOTO :EOF

:print
IF *%2==* GOTO :EOF
SET _type=%~1
SET _ok=FALSE
IF /I "%_type:~0,5%"=="text/" SET _ok=TRUE
IF /I NOT "%_ok%"=="TRUE" GOTO :EOF
:loop
SHIFT
IF *%1==* GOTO :EOF
CALL :add_ext %1
GOTO loop
GOTO :EOF

:add_ext
IF *%1==* GOTO :EOF
IF NOT DEFINED _ext SET _ext=%*
IF     DEFINED _ext SET _ext=%_ext% %*
GOTO :EOF

:test
FOR /F "usebackq delims=" %%A IN ('CALL :test2 %*') DO ECHO %%A
GOTO :EOF

:test2
ECHO %1 %2=%%%~3%%
GOTO :EOF
