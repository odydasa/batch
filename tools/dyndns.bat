@ECHO OFF
SETLOCAL

SET _username=odydasa
SET _password=kocoks
SET _hostname=odydasa.ddns.net
SET _urlUpdate="http://##USERNAME##:##PASSWORD##@dynupdate.no-ip.com/nic/update?hostname=##HOSTNAME##&myip=##IP##"

CALL :init
CALL :getIP

ECHO Updating IP for hostname %_hostname%
ECHO External IP: %IP%
CALL :run "%_curl%" %%_urlUpdate:##IP##=%IP%%%
GOTO :EOF


:init
SET _IPFile=%tmp%\ip
SET _curl=curl.exe
SET _awk=awk.exe
SET _urlIP=http://checkip.dyndns.org
SET _urlCURL=https://curl.se/windows/curl-win32-latest.zip
SET _urlAWK=https://telkomuniversity.dl.sourceforge.net/project/gnuwin32/gawk/3.1.6-1/gawk-3.1.6-1-bin.zip

FOR %%A IN (curl awk) DO SET _%%~AOK=
FOR %%A IN (%PATH%) DO FOR %%B IN (curl awk) DO (
  CALL :run IF EXIST "%%~A\%%_%%~B%%" SET _%%~BOK=OK
  CALL :run IF EXIST "%%~A\%%_%%~B%%" SET _%%~B=%%~A\%%_%%~B%%
)
FOR %%A IN (cURL awk) DO IF NOT DEFINED _%%~AOK (
  ECHO %%~A is not found.
  IF NOT EXIST "%tmp%\_files" MD "%tmp%\_files"
  ECHO [] Downloading...
  CALL :run powershell -command "& { (New-Object Net.WebClient).DownloadFile('%%_url%%~A%%', '%tmp%\_files\%%~A.zip') }"
  ECHO [] Extracting...
  IF EXIST "%tmp%\_files\%%~A" RD /S /Q "%tmp%\_files\%%~A"
  CALL :run powershell -command "Expand-Archive '%tmp%\_files\%%~A.zip' '%tmp%\_files\%%~A'" 
  FOR %%B IN (cURL) DO IF /I "%%~A"=="%%~B" (
    FOR /D %%C IN ("%tmp%\_files\%%~A\*") DO CALL :run SET _%%~A=%%~C\bin\%%_%%~A%%
  )
  FOR %%B IN (awk) DO IF /I "%%~A"=="%%~B" (
    CALL :run SET _%%~A=%tmp%\_files\%%~A\bin\%%_%%~A%%
  )
  ECHO.
)
REM FOR %%A IN (cURL awk) DO CALL :run ECHO %%~A is found: %%_%%~A%%
ECHO.
CALL :run SET _urlUpdate=%%_urlUpdate:##USERNAME##=%_username%%%
CALL :run SET _urlUpdate=%%_urlUpdate:##PASSWORD##=%_password%%%
CALL :run SET _urlUpdate=%%_urlUpdate:##HOSTNAME##=%_hostname%%%
GOTO :EOF

:getIP
"%_curl%" -s -o "%_IPFile%.txt" %_urlIP% >nul 2>&1
"%_awk%" "{split($0,ar,\":\"); ip = substr(ar[2], 1,index(ar[2],\"/\") - 2); printf(\"SET IP=%%s\n\",ip);}" "%_IPFile%.txt" >"%_IPFile%.bat"
CALL "%_IPFile%.bat"
SET IP=%IP: =%
GOTO :EOF

:run
%*
GOTO :EOF
