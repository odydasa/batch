@ECHO OFF
FOR /D /R storage %%A IN (*.*) DO (
  mountvol "%%~A" /D >nul
)