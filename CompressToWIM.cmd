@echo off
setlocal EnableExtensions
setlocal EnableDelayedExpansion
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

if NOT exist bin.zip goto UIFC

if exist bin.zip goto extract

:extract
powershell -command "Expand-Archive bin.zip"
erase bin.zip /s /q
rename bin tools
goto UIFC

rename bin tools
goto UIFC

:UIFC
cls
title Please enter folder or drive which you want to compress. but you can't compress the file. For files, you must create a folder and put it in a folder and compress the folder.
echo =============================================================================================================================================================================
echo Please enter folder or drive which you want to compress. but you can't compress the file. For files, you must create a folder and put it in a folder and compress the folder.
echo =============================================================================================================================================================================
set /p userinputforcompress=

goto UIFCWTP

:UIFCWTP
cls
title Please enter to where to put the wim file.
echo ===========================================
echo Please enter to where to put the wim file.
echo ===========================================
set /p userinputforcompresswheretoput=

goto Getting_ready

:Getting_ready
title Ready to compress to wim file.
cls
tools\dism /capture-image /imagefile:%userinputforcompresswheretoput%\compressed.wim /capturedir:%userinputforcompress% /name=DESC

if NOT exist %userinputforcompresswheretoput%\compressed.wim goto FAILURE

if exist %userinputforcompresswheretoput%\compressed.wim goto Success

:FAILURE
cls
color 0c
title FAILURE :(
echo We reported during compress to wim.
echo Press any key to exit...
pause>nul
exit

:Success
cls
title Successful!
echo We Successfully to make wim!
echo Press any key to exit...
pause>nul
exit