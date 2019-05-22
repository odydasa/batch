@ECHO OFF
FOR %%A IN (jdkpath programsdir shared _ path.old) DO (
  FOR /F "usebackq delims==" %%B IN (`SET %%~A`) DO SET %%B=>nul
)
SET PATH=%SystemRoot%\system32;%SystemRoot%\WINDOWS;%SystemRoot%\system32\wbem
