@ECHO OFF
SETLOCAL
CALL :init %*

CALL :setPattern ##TYPE##_##DATE##_##SERIES##*.*
CALL :setTypeDateSeries ???,0,3 ; ????????,4,8 ; ??????,13,6
CALL :job

CALL :setPattern ##TYPE##-##DATE##-##SERIES##.*
CALL :setTypeDateSeries ???,0,3 ; ????????,4,8 ; ??????,13,6
CALL :job

REM This pattern ruin other files
REM CALL :setPattern ##TYPE####DATE####SERIES##*.*
REM CALL :setTypeDateSeries ???,0,3 ; ????????,3,8 ; ??????,11,6
REM CALL :job

CALL :setPattern ##DATE##_##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????????,0,8 ; ??????*,9,6
CALL :job

CALL :setPattern ##DATE## ##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????-??-??,0,10 ; ??.??.??*,11,8
CALL :job

CALL :setPattern ##DATE## ##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????-??-??,0,10 ; ??_??_??*,11,8
CALL :job

REM 00000000001111111111222222222
REM 01234567890123456789012345678
REM PHOTO-YYYY-MM-DD-HH-mm-ss.jpg
CALL :setPattern photo-##DATE##-##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????-??-??,6,10 ; ??-??-??*,17,8
CALL :job

REM Screenshot_YYYY-MM-DD-HH-mm-ss-*.jpg
CALL :setPattern Screenshot_##DATE##-##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????-??-??,11,10 ; ??-??-??*,22,8
CALL :job

CALL :setPattern Screenshot ##DATE## ##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????-??-??,11,10 ; ??.??.??*,22,8
CALL :job

REM Capture-YYYY-MM-DD HH_mm_ss*.jpg
CALL :setPattern Capture-##DATE## ##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????-??-??,8,10 ; ??_??_??*,22,8
CALL :job

REM Capture-YYYYMMDD-HHmmss*.jpg
CALL :setPattern Capture-##DATE##-##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????????,8,8 ; ??????*,17,6
CALL :job

CALL :setPattern Capture ##DATE## ##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????????,8,8 ; ??????*,17,6
CALL :job

CALL :setPattern Capture-##DATE##_##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????????,8,8 ; ??????*,17,6
CALL :job

CALL :setPattern Capture-##DATE##.##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????????,8,8 ; ??????*,17,6
CALL :job


REM DSC?????-????-??-??*.jpg
CALL :setPattern DSC##SERIES##-##DATE##*.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????-??-??,9,10 ; ?????,3,5
CALL :job

REM IMG_????-????-??-??*.jpg
CALL :setPattern IMG_##SERIES##-##DATE##*.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????-??-??,9,10 ; ????,4,4
CALL :job

REM 0000000000111111111122222222223333333333444
REM 0123456789012345678901234567890123456789012
REM WhatsApp Image ????-??-?? at ??.??.??*.jpeg
CALL :setPattern WhatsApp Image ##DATE## at ##SERIES##*.##TYPE##
CALL :setTypeDateSeries ???,-4,4 ; ????-??-??,15,10 ; ??.??.??*,29,8
CALL :job

REM 0000000000111111111122222222223333333333444
REM 0123456789012345678901234567890123456789012
REM WhatsApp Video ????-??-?? at ??.??.??*.mp4
CALL :setPattern WhatsApp Video ##DATE## at ##SERIES##*.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????-??-??,15,10 ; ??.??.??*,29,8
CALL :job

REM 0000000000111111111122222222223333333333444
REM 0123456789012345678901234567890123456789012
REM WhatsApp Audio ????-??-?? at ??.??.??*.ogg
CALL :setPattern WhatsApp Audio ##DATE## at ##SERIES##*.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????-??-??,15,10 ; ??.??.??*,29,8
CALL :job

:end
ENDLOCAL
GOTO :EOF

:init
SET _param=
SET _media=IMG VID AUD DOC
SET _mediaAUD=aac mp3 ogg wav wma
SET _mediaDOC=doc docx pdf pps ppt pptx txt
SET _mediaIMG=jpg jpeg png
SET _mediaVID=3gp mov mp4 mpg
IF /I "%~1"=="--year" SET _param=0
IF /I "%~1"=="--year-month" SET _param=1
IF /I "%~1"=="--year-date" SET _param=2
IF /I "%~1"=="--year-month-date" SET _param=3
FOR /L %%A IN (0,1,3) DO IF /I "%~1"=="-p%%~A" SET _param=%%~A

GOTO :EOF

:job
FOR %%A IN ("%_patternList%") DO IF EXIST %%A CALL :files2Folder %%~A
GOTO :EOF

:setPattern
SET _pattern=%*
SET _patternList=%_pattern%
:ECHO %_patternList%
GOTO :EOF

:setTypeDateSeries
SET _tmp=%*
SET _tmp=%_tmp:,=#%
FOR /F "usebackq tokens=1,3,1-3" %%A IN (`ECHO %_tmp%`) DO (
  SET _patternType=%%~A
  SET _patternDate=%%~B
  SET _patternSeries=%%~C
)
FOR %%A IN (type date series) DO (
  CALL :run SET _pattern%%A=%%_pattern%%A:#=,%%
  FOR /F "tokens=1,3,1-3 delims=," %%B IN ('ECHO %%_pattern%%A%%') DO CALL :run SET _patternList=%%_patternList:##%%A##=%%B%% 
)
IF EXIST "%_patternList%" (
 REM ECHO %_patternList%
 REM DIR /B "%_patternList%"
 REM ECHO.
)
SET _tmp=
GOTO :EOF

:getType
IF "%~1"=="" GOTO :EOF
IF "%~2"=="" GOTO :EOF
FOR %%A IN (%_media%) DO (
  CALL :run IF /I "%%%~1%%"=="%%~A" SET %~1=%%A
  CALL :run IF /I "%%%~1%%"=="%%~A" GOTO :EOF
)
CALL :run SET _tmp=%%_media%~2%%
FOR %%A IN (%_tmp%) DO (
  CALL :parse IF /I "%%%~1%%"=="%%A" SET %~1=%~2
  CALL :parse IF /I "%%%~1%%"=="%%A" SET _tmp=
)
SHIFT /2
IF NOT DEFINED _tmp GOTO :EOF
GOTO getType
GOTO :EOF

:files2Folder
SET _x=%*
SET _flist=%_pattern%

FOR %%A IN (type date series) DO FOR /F "tokens=1,3,1-3 delims=," %%B IN ('ECHO %%_pattern%%A%%') DO (
  IF /I "%%A"=="series" (
    CALL :parse SET _f%%A=%%B
  ) ELSE (
    CALL :parse SET _f%%A=%%_x:~%%C,%%D%%
  )
  CALL :parse SET _flist=%%%%_flist:##%%A##=%%_f%%A%%%%%%
)
CALL :getType _ftype %_media%
FOR %%A IN (" " - _ ) DO CALL :run SET _fdate=%%_fdate:%%A=%%
IF "%_param%"=="0" SET _fdate=%_fdate:~0,4%
IF "%_param%"=="1" SET _fdate=%_fdate:~0,4%\%_fdate:~4,2%
IF "%_param%"=="2" SET _fdate=%_fdate:~0,4%\%_fdate%
IF "%_param%"=="3" SET _fdate=%_fdate:~0,4%\%_fdate:~4,2%\%_fdate%
ECHO %_ftype%\%_fdate%\%_flist%
IF NOT EXIST "%_ftype%\%_fdate%" MD "%_ftype%\%_fdate%"
MOVE /Y "%_flist%" "%_ftype%\%_fdate%" && ECHO.
GOTO :EOF

:parse
CALL :run %*
GOTO :EOF

:run
%*
GOTO :EOF
