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
echo.
echo ===========================================================================================================================================
echo Please enter folder or drive which you want to compress. For files, you must create a folder and put it in a folder and compress the folder.
echo ENSURE THAT DERECTORY HAS NO SPACE OTHERWISE IT WILL NOT WORK.
echo ===========================================================================================================================================
set /p userinputforcompresswhat=

goto UIFCWTP

:UIFCWTP
cls
title Please enter to where to put the wim file.
echo.
echo ===========================================
echo Please enter to where to put the wim file.
echo AGAIN, ENSURE THAT DERECTORY HAS NO SPACE OTHERWISE IT WILL NOT WORK
echo ===========================================
set /p userinputforcompresswheretoput=

goto Getting_ready

:Getting_ready
title Ready to compress to wim file.
cls
tools\wimlib-imagex.exe capture %userinputforcompresswhat% %userinputforcompresswheretoput%\compressed.wim NAME DESC --compress=LZX --check --threads=max
cls
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
echo We successful to make wim!
echo Press any key to exit...
pause>nul
cd /d %userinputforcompresswheretoput%
explorer .
exit