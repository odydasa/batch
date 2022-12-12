@ECHO OFF
FOR %%A IN ("%CD%") DO (
  FOR %%B IN (gaper-f1 odydasa dr-indah avissena jenar) DO (
    IF /I NOT "%%~B"=="%ComputerName%" blinksync "%%~A" "\\%%~B\D$%%~pnxA"
  )
)
