@ECHO OFF
SET _noDuplicationException=readme.* setup.*

CALL :fix_path _noDuplicationSource %~1
CALL :fix_path _noDuplicationTarget %~2


SET _MyCMD=CALL %~dps0callPHP -f "%~dps0%~n0.php"
%_MyCMD% "%_noDuplicationSource%" "%_noDuplicationTarget%" "%_noDuplicationException%"

GOTO end


:fix_path
REM Usage: CALL :fix_path VAR_NAME PATH
SET _noDuplicationTmp1=%~2
IF NOT DEFINED _noDuplicationTmp1 SET _noDuplicationTmp1=.
FOR /F "usebackq delims=" %%A IN ('%_noDuplicationTmp1%') DO SET _noDuplicationTmp1=%%~fA
IF "%_noDuplicationTmp1:~-1%"=="\" SET _noDuplicationTmp1=%_noDuplicationTmp1:~0,-1%
SET _noDuplicationTmp2=FALSE
FOR %%A IN ("%_noDuplicationTmp1%") DO SET _noDuplicationTmp2=TRUE
IF /I %_noDuplicationTmp2%==TRUE IF EXIST "%_noDuplicationTmp1%\" SET _noDuplicationTmp1=%_noDuplicationTmp1%\*.*
SET %1=%_noDuplicationTmp1%
SET _noDuplicationTmp1=
GOTO :EOF

:end
FOR %%A IN (myCMD) DO @SET _%%A=
FOR %%A IN (Source Target Exception Tmp1 Tmp2) DO SET _noDuplication%%A=
