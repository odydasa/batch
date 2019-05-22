@ECHO OFF
SET http_proxy=172.16.1.1:8080

IF NOT "%~1"=="" SET http_proxy=%~1
SET ftp_proxy=%http_proxy%
