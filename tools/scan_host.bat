@ECHO OFF
CLS
FOR /L %%A IN (1,1,253) DO @(
  ECHO %1.%%A:
  FOR /F "usebackq" %%B IN (`PING %1.%%A -n 1 -i 1 -l 1 -w 1`) DO @(
    IF "%%B"=="Reply" (
      ECHO   Connected
    )
  )
)



