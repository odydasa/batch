@ECHO OFF
SET ___tmpBat="%tmp%\~$%RANDOM%%RANDOM%%RANDOM%%RANDOM%.bat"
%*>%___tmpBat%
CALL %___tmpBat%
ECHO Y|DEL %___tmpBat%>nul
SET ___tmpBat=
