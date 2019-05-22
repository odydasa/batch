@ECHO OFF
SETLOCAL
SET _lameCmd=lame.exe -b 128 -m s -c -s 44.1 --cbr -k --strictly-enforce-ISO --mp3input
SET _lameCmd=lame.exe -b 128 -m s -c -s 44.1 --cbr -k --strictly-enforce-ISO
SET _lameErrorCodes="Empty file";"File not found";"File must be: ";"Encoding error"
SET _lameValidExt=wav mp3
SET _lameExt=mp3

CALL :init %_lameErrorCodes%

:proccess
IF "%~1*"=="*" GOTO end
FOR %%A IN ("%~1") DO CALL :fix "%%~A"
SHIFT
GOTO proccess

:fix
SET _lameErorMsg=
SET _lameExt=%_lameExt%
SET _validExt=
IF "%~1*"=="*"      SET _lameErrorMsg=%_lameErrorCode0%
IF NOT EXIST "%~1" (
  SET _lameErrorMsg=%_lameErrorCode1%
) ELSE (
  CALL :isValidExt "%~1"
)
IF NOT "%_validExt%"=="1" SET _lameErrorMsg=%_lameErrorCode2%
IF DEFINED _lameErrorMsg (
   CALL :error "%~1" "%_lameErrorMsg%"
) ELSE (
  IF EXIST "%~dp1%~n1.%_lameExt%" SET _lameExt=%_lameExt%-
)
IF NOT DEFINED _lameErrorMsg (
  %_lameCmd% "%~1" "%~dp1%~n1.%_lameExt%"
  IF ERRORLEVEL 1 CALL :error "%~1" "%_lameErrorCode3%"
)
ECHO. 
GOTO :EOF

:isValidExt
IF "*%~1*"=="**" GOTO :EOF
SET _validExt=
FOR %%A IN (%_lameValidExt%) DO (
  IF /I "%~x1"==".%%~A" CALL :setValidExt 1
)
GOTO :EOF

:setValidExt
SET _validExt=%*
GOTO :EOF

:init
SET _lameCodeCounter=0
:loop
IF "*%~1*"=="**" GOTO initNext
SET _lameErrorCode%_lameCodeCounter%=%~1
SHIFT
IF "*%~1*"=="**" GOTO initNext
SET /A _lameCodeCounter+=1
GOTO :loop
:initNext
SET _lameErrorCode2=%_lameErrorCode2% %_lameValidExt: =/%
GOTO :EOF

:error
ECHO ERROR processing "%~1"
ECHO : %~2
GOTO :EOF

:end
FOR %%A IN (cmd) DO SET _%%A=
ENDLOCAL
