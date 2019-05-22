@ECHO OFF
SET _ThisFile=%~n0
SET _MyCMD=CALL %~dps0callPHP -f %~dps0%~ns0.php
IF A%1A==AA GOTO help
%_MyCMD% %*
GOTO end

:help
ECHO.
ECHO Using: %_thisfile% FunctionName [functionParam1 [functionParam2 [...]]]
ECHO.

:end
FOR %%A IN (ThisFile varOK myCMD) DO @SET _%%A=

