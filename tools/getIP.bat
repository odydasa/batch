@ECHO OFF
FOR %%A IN (release renew flushdns registerdns displaydns all) DO ipconfig /%%A
