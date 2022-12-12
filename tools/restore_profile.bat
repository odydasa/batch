@ECHO OFF
rar x -k -r -y Profile.rar .\
icacls profile\ /reset /c /t /l
icacls profile\ /setowner everyone /c /t /l
icacls profile\ /grant everyone:f /c /t /l
attrib -a -r -s -h profile\* /l /s 

