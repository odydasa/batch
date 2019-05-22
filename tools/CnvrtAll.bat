@echo off
SET MyList=txt bat cmd nt cfg ini inf log asc reg key err types cnf conf diz nfo
SET MyList=%MyList% url htm html html.var htx shtm shtml htt mht mhtm mhtml xht xhtml 
SET MyList=%MyList% hta css mime msg emf nws sgm sgml mht mhtml sql
SET MyList=%MyList% asa asp cdx php php3 php4 inc js jse wsf wsh wsc vbs vbe cgi 
SET MyList=%MyList% pl pm al py java m tc tcl tk c h ch pas bas asm mak bpr cpp gcc
SET MyList=%MyList% csv ts vcf xml xsl ldb org ppc pwd prf PrjGrp ewb tmpl dal

SET AddList=sh csh tcsh allow bashrc cshrc deny globals login template bash* dtd alias

SET JumpCMD=CALL :change_crlf
SET ConvCMD=-bin
SET ConvVar=-d
IF NOT A%3A==AA GOTO help
IF A%1A==AA (SET Error1=0) ELSE (SET Error1=1)
IF A%2A==AA (SET Error2=0) ELSE (SET Error2=1)
FOR %%A IN (-d -u -php -bin) DO @(
  IF NOT A%1A==AA IF /I A%%AA==A%1A SET Error1=0
  IF NOT A%2A==AA IF /I A%%AA==A%2A SET Error2=0
)
IF %Error1%==1 GOTO help
IF %Error2%==1 GOTO help
FOR %%A IN (-d -u) DO @(
  FOR %%B IN (-d -u) DO IF /I %%A==%1 IF /I %%B==%2 goto help
  IF /I %%A==%1 SET ConvVar=%1
  IF /I %%A==%2 SET ConvVar=%2
)
FOR %%A IN (-php -bin) DO @(
  FOR %%B IN (-php -bin) DO IF /I %%A==%1 IF /I %%B==%2 goto help
  IF /I %%A==%1 SET ConvCMD=%1
  IF /I %%A==%2 SET ConvCMD=%2
)
IF %ConvVar%==-u SET MyList=%MyList% %AddList%
IF /I %ConvCMD%==-php SET ConvCMD=TConv
IF /I %ConvCMD%==-bin @(
  SET ConvCMD=conv
  IF %ConvVar%==-d SET ConvVar=--safe -D
  IF %ConvVar%==-u SET ConvVar=--safe -U
)

ECHO %ConvCMD% %ConvVar%
ECHO.
SET AddList=%MyList%
SET MyList=*.
FOR %%A IN (%AddList%) DO CALL :set_list %%A

SET tmpCount=
FOR %%A IN (%MyList%) DO ATTRIB -a -r %%A /s
FOR /R %%A IN (%MyList%) DO @%JumpCMD% "%%~fA"
IF A%tmpCount%A==AA ECHO No file found
goto end

:set_list
SET MyList=%MyList% *.%~1
GOTO :EOF

:change_crlf
SET CurDir=%~dp1
:IF [%1]==["%CurDir%desktop.ini"] goto :EOF 
:IF [%1]==["%CurDir%autorun.inf"] goto :EOF
CALL %ConvCMD% %ConvVar% %1 > nul
SET tmpCount=OK
goto :EOF

:help
ECHO.
ECHO Usage: %thisfile% [option]
ECHO.
ECHO   Option:
ECHO     -d     Output will be in DOS format
ECHO     -u     Output will be in UNIX format
ECHO     -bin   Output will be proccessed with conv.exe
ECHO     -php   Output will be proccessed with TConv.php
ECHO.
GOTO end

:end
FOR %%A in (MyList JumpCMD ConvCMD ConvVar CurDir) DO SET %%A=
