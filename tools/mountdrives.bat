@ECHO OFF
net use /persistent:yes
net use
FOR %%A IN (z:gaper-f1 y:odydasa x:dr-indah w:avissena v:jenar) DO (
  FOR /F "tokens=1,2,* delims=:" %%B IN ("%%~A") DO (
    ECHO Mounting \\%%C\$d to %%B: 
    net use %%B: \\%%C\d$ /savecred || ECHO   Error!
    ECHO.
  )
)
net use