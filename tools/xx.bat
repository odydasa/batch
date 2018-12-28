@ECHO OFF
SET _xx_tmp=%tmp%\~$xx_tmp%RANDOM%%RANDOM%%RANDOM%.tmp
TYPE %1|SORT>"%_xx_tmp%"
TYPE "%_xx_tmp%"|uniq>%1
DEL /F /Q "%_xx_tmp%"
SET _xx_tmp=
