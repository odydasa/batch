@ECHO OFF
runas /user:administrator /savecred "notepad '%SystemRoot%\System32\drivers\etc\hosts'"
