@ECHO OFF
SET audioPlayer=%~dp0playAudio.jar 
SET audioFile=%~dp0chimes.wav
IF NOT EXIST %audioPlayer% GOTO PlayBeep
IF NOT EXIST %audioFile% GOTO PlayBeep
java -jar %audioPlayer% %audioFile%
GOTO end

:PlayBeep
ECHO 
GOTO end

:end
for %%a in (Player File) do @set audio%%a=
GOTO :EOF