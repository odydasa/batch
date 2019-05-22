@ECHO OFF
SETLOCAL
CALL :init %*

CALL :setPattern ##TYPE##_##DATE##_##SERIES##*.*
CALL :setTypeDateSeries ???,0,3 ; ????????,4,8 ; ??????,13,6
CALL :job

CALL :setPattern ##TYPE##-##DATE##-##SERIES##.*
CALL :setTypeDateSeries ???,0,3 ; ????????,4,8 ; ??????,13,6
CALL :job

CALL :setPattern ##DATE##_##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????????,0,8 ; ??????*,9,6
CALL :job

CALL :setPattern ##DATE## ##SERIES##.##TYPE##
CALL :setTypeDateSeries ???,-3,3 ; ????-??-??,0,10 ; ??.??.??*,11,8
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
IF /I "%~1"=="--year" SET _param=1
IF /I "%~1"=="--month-year" SET _param=2
GOTO :EOF

:job
FOR %%A IN ("%_patternList%") DO IF EXIST %%A CALL :files2Folder %%~A
GOTO :EOF

:setPattern
SET _pattern=%*
SET _patternList=%_pattern%
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
IF "%_param%"=="1" SET _fdate=%_fdate:~0,4%\%_fdate%
IF "%_param%"=="2" SET _fdate=%_fdate:~0,4%\%_fdate:~4,2%\%_fdate%
ECHO %_ftype%\%_fdate%\%_flist%
IF NOT EXIST "%_ftype%\%_fdate%" MD "%_ftype%\%_fdate%"
MOVE /Y "%_flist%" "%_ftype%\%_fdate%" > nul

GOTO :EOF

:parse
CALL :run %*
GOTO :EOF

:run
%*
GOTO :EOF
