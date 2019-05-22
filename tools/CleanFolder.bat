@ECHO OFF
FOR /F "delims=" %%A IN ('DIR /AD /B') DO (
  ECHO %%~A
  RD /S /Q "%%~A"
  MD "%%~A"
)