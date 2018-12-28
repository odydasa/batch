@ECHO OFF
IF     "%~1"=="" GOTO :EOF
IF NOT "%~2"=="" GOTO :EOF
SET _Cmd=pdftotext -nopgbrk -layout
SET _curPath=%CD%
SET _tmpFile_pdf_dump=%tmp%\~$pdf_dump_temp%RANDOM%%RANDOM%%RANDOM%.txt

%_Cmd% "%~1" "%_tmpFile_pdf_dump%"
TYPE "%_tmpFile_pdf_dump%"
CD /D "%_curPath%"
IF EXIST "%_tmpFile_pdf_dump%" (
  ATTRIB -a -r -s -h "%_tmpFile_pdf_dump%"
  DEL /F "%_tmpFile_pdf_dump%"
)
FOR %%A IN (curPath dumpCmd dumpParam dumpFile dumpPath tmpFile) DO SET _%%A=
FOR %%A IN (Name AllShort Path) DO SET _file%%A=
GOTO :EOF
