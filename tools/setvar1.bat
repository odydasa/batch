@ECHO OFF
SET _1=.\setvar
SET _2=@setvar1 %%*
IF *%1==* GOTO :restore

> %_1% echo n %_1%.bat
>>%_1% echo e 100 "@SET _3="
>>%_1% echo rcx
>>%_1% echo 08
>>%_1% echo w
>>%_1% echo q
debug <%_1%>nul
%2 %3 %4 %5 %6 %7 %8 %9>>%_1%.bat
CALL .\%_1%.bat>nul
SET %1=%_3%

:restore
ECHO %_2%>%_1%.bat
IF EXIST %_1% ECHO Y|DEL %_1%
FOR %%A IN (1 2 3) DO SET _%%A=
