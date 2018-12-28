@ECHO OFF
SET _ThisFile=%~n0
SET _Syncronize_target=%~1
SET _Syncronize_pattern=%~2
IF "%~1"=="" GOTO help
IF NOT DEFINED _Syncronize_pattern SET _Syncronize_pattern=*.*
xcopy /C /F /H /R /U /K /Y "%_Syncronize_target%%_Syncronize_pattern%" .
GOTO end
FOR /R %%A IN (*.*) DO (
  IF EXIST "%_Syncronize_target%%%~nxA" (
    :ECHO %_Syncronize_target%%%~nxA
    xcopy /M /C /F /H /R /U /K /Y "%_Syncronize_target%%%~nxA"
  ) ELSE (
    ECHO NOT exist: %_Syncronize_target%%%~nxA
  )
)
GOTO end

:help
ECHO Replace all occurrences of the search string with the replacement string
ECHO of given file
ECHO.
ECHO Using: %_thisfile% source_path [file_pattern]
ECHO.
GOTO end

:end
FOR %%A IN (ThisFile) DO @SET _%%A=
FOR /F "usebackq delims==" %%A IN (`SET _Syncronize`) DO SET %%A=
