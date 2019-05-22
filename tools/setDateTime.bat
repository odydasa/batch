@ECHO OFF
SETLOCAL
CALL :init
FOR %%A IN ("%_format%.jpg") DO CALL :setDateTime "%%~A"
ENDLOCAL
GOTO :EOF

:init
SET _stamp=
SET _format=????-??-?? ??.??.??
SET _parse_YYYY=0,4
SET _parse_MM=5,2
SET _parse_DD=8,2
SET _parse_hh=11,2
SET _parse_nn=14,2
SET _parse_ss=17,2
REM touch format: MMDDhhnnYYYY.ss
GOTO :EOF

:setDateTime
SET _file=%~1
SET _stamp=
CALL :run SET _stamp=%%_stamp%%%%_file:~%_parse_DD%%%-
CALL :run SET _stamp=%%_stamp%%%%_file:~%_parse_MM%%%-
CALL :run SET _stamp=%%_stamp%%%%_file:~%_parse_YYYY%%%
CALL :run SET _stamp=%%_stamp%% %%_file:~%_parse_hh%%%.
CALL :run SET _stamp=%%_stamp%%%%_file:~%_parse_nn%%%.
CALL :run SET _stamp=%%_stamp%%%%_file:~%_parse_ss%%%
ECHO Set date time
ECHO   File: %~1
ECHO   Time: %_stamp%
nircmdc setfiletime "%~1" "%_stamp%" "%_stamp%" "%_stamp%"
GOTO :EOF

:setDateTimeXXX
SET _file=%~1
SET _stamp=
CALL :run SET _stamp=%%_stamp%%%%_file:~%_parse_MM%%%
CALL :run SET _stamp=%%_stamp%%%%_file:~%_parse_DD%%%
CALL :run SET _stamp=%%_stamp%%%%_file:~%_parse_hh%%%
CALL :run SET _stamp=%%_stamp%%%%_file:~%_parse_nn%%%
CALL :run SET _stamp=%%_stamp%%%%_file:~%_parse_YYYY%%%
CALL :run SET _stamp=%%_stamp%%.%%_file:~%_parse_ss%%%
ECHO Set date time
ECHO   File: %~1
ECHO   Time: %_stamp%
touch -amt %_stamp% "%~1"
GOTO :EOF

:run
%*
GOTO :EOF
